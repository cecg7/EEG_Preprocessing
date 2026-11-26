function [brain_perc,brain_perc_clean]=IC_MARBLE(filt_folder,clean_folder)
%% 0) Empty table to store IC information of %brain and %artifacts:
path = filt_folder;                     % Filtered files in a branch of nested folder
set_files = dir([path '\*.set']);% identifying filtered files in the brach 
len1=length(set_files);                 % counting filtered files in the branch
% *-*-* Before preprocessing *-*-*
brain_perc = array2table(zeros(len1,7));% Column 1: Brain(%); Columns 2-7: Artifacts(%) 
brain_perc.Var8 = strings([len1,1]);    % Column 8: Participant Code
brain_perc.Var9 = brain_perc.Var8;    % Column 9: Group
% *-*-* After preprocessing *-*-*
brain_perc_clean = brain_perc;                  % Same as before
brain_perc_clean.Var10 = (zeros(len1,1));       % Total ICs (before IC rejection)
brain_perc_clean.Var11 = brain_perc_clean.Var10;% Remained ICs (after IC rejction)
brain_perc_clean.Var12 = brain_perc_clean.Var10;% Rejected ICs
brain_perc_clean.Var13 = brain_perc_clean.Var10;% Interpolated channels

    for i = 1:len1                      % for loop to preprocess and save clean files in the branch
        %% 1) Loading filtered [.SET] files (once the manual inspection has been completed)
        filename = set_files(i).name;
        EEG = pop_loadset([path '\' filename]);    
        chan_locs = readlocs('32Ch_gTec.ced');  % loading channel location file
        EEG.chanlocs = chan_locs;               % importing channel loc to EEG file
        
        %% 2) Remove Channel Drift by ASR
        EEG = pop_clean_rawdata(EEG, 'FlatlineCriterion','off',...
            'ChannelCriterion','off','LineNoiseCriterion','off',...
            'Highpass',[0.25 0.75] ,'BurstCriterion','off',...
            'WindowCriterion','off','BurstRejection','off',...
            'Distance','Euclidian');
        %% 3) Specify the corrupted channels to exclude them from the ICA weights calculation
        bad_chs_all = readtable('CHS_interpolation.xlsx',...     % Importing TABLE.xlsx and 
            'Sheet', 'Baseline_S1');                             % SHEET containing corrupted channels
        bad_chs = table2array(bad_chs_all(:,2:end));    % Transforming table to array
        idx_bad_chs = find(bad_chs(i,:)==1);            % Corrupted channel indexes from the "i"nth subject
    
        %% 4) ICA Weights
        % 4.1) Cloning EEG data
        EEGica = EEG;               
   
        % 4.2) Excluding corrupted channels indexes from the ICA weights calculation
        ICs_OK = 1:EEG.nbchan;      % Creating vector from [1:number of channels]
        ICs_OK(idx_bad_chs) = [];   % Excluding corrupted channels indexes
    
        % 4.3) Runing ICA Weights ignoring corrupted channels
        EEGica = pop_runica(EEGica,'extended', 1, 'chanind', ICs_OK);

        % 4.4) Importing ICA Weights to EEG file (from the cloned dataset to the post-ASR stage)
        EEG.icawinv = EEGica.icawinv;
        EEG.icasphere = EEGica.icasphere;
        EEG.icaweights = EEGica.icaweights;
        EEG.icachansind = EEGica.icachansind;
        %% 5) ICLabel
        EEG_IC = iclabel(EEG);  % Running ICLabel algorith 
        
        %% 6) Saving Percentages of Brain and Artifacts before IC Rejection
        % 6.1) Getting brain and artifact proportions BEFORE IC rejection
        aux = EEG_IC.etc.ic_classification.ICLabel.classifications; 
        
        % 6.2) Creating [TABLE] with avergae brain and artifact proportions
        t_aux = array2table(mean(aux));                             
        t_aux = renamevars(t_aux,t_aux.Properties.VariableNames,... 
            EEG_IC.etc.ic_classification.ICLabel.classes);              
        
        % 6.3) Participant's code - [TABLE]
        t_subj_code = table({extractBefore(filename,"_")});         
        t_subj_code = renamevars(t_subj_code,t_subj_code.Properties.VariableNames,...
        'Participant Code');
        
        % 6.4) Participant's study group - [TABLE]
        t_group = cell2table(extractBetween(filename,"_","."));
        t_group = renamevars(t_group,t_group.Properties.VariableNames,...
        'Group');
        
        % 6.5) Concatenate tables generated in steps 5.2-5.4
        brain_perc(i,:) = [t_aux,...
        t_subj_code,t_group];
        %% 7) Automatic IC rejection
        
        % 7.1) Identifying the max. proportion in each IC (brain/artifacts)
        r =[];   % auxiliary variable
        [r(:,1),r(:,2)] = find(aux == max(aux,[],2)); % r(:,1) - IC number, r(:,2) - ICLabel class 
        
        % 7.2) Max. Proportion ordered by ICLabel class (1. Brain, 2. Muscle, etc.)
        c=[];   % auxiliary variable
        for p = 1:length(r)
            c(p)=aux(r(p,1),r(p,2)); % max. proportion per row and ordered by ICLabel class
        end
        
        % 7.3) Concatenate IC number, ICLabel class, and proportion
        r=[r c'];
    
        % 7.4) Adding Brain Proportion for each IC
        w=zeros(length(ICs_OK),4); % auxiliaty variable
        for p=1:length(r)
            w(p,:)=[r(p,:) aux(r(p,1))]; % getting Brain Proportion by IC
        end
    
        % 7.5) Rearranging matrix
        w=sortrows(w,'ascend');    % Sort matrix order in ascending order by IC
        q = table(w, EEG_IC.etc.ic_classification.ICLabel.classes(w(:,2))'); % add the ICLabel class name, based on its number
               
        % 7.6) IC rejection 
        rej=[];     % auxiliar variable for IC rejection     
        t=1;        % auxiliar counter for rejected components
        for p = 1:length(w)
            idx_maxIC = find(aux(p,:)== max(aux(p,:))); % getting max. ICLabel class
            flag_other = 1;        % Always activate flag_other
            if idx_maxIC == 7      % If max. ICLabel class is OTHER
                idx_2maxIC = find(aux(p,1:6)== max(aux(p,1:6))); % Find OTHER proportion
                if idx_2maxIC == 1 && aux(p,1) >= 0.2 
                    flag_other = 0; % Turn off Other Flag if OTHER > = 0.2
                else
                    flag_other = 1; % Turn on Other Flag if OTHER > = 0.2
                end
            end
        % *-*-*-*-*-*-*-* CONDITIONS *-*-*-*-*-*-*-*
        % Reject IC if 3 conditions are satisfied:
        %   1. Max. proportion is not Brain 
        %       * In code: w(p,2)~=1
        %   2. IC_brain / IC_max ratio is >= 0.5, where:
        %       * IC_brain is the proportion of Brain from the "n" IC
        %       * IC_max is the max. proportion of the "n" IC
        %       * In code: w(p,4)/w(p,3)<=0.5
        %   3. Flag_other is turned on 
        %       * In code: flag_other == 1
        % In other words: 
        %   1. It keeps IC whose max. proportion is Brain
        %   2. It rejects IC if the ratio between brain proportion and 
        %       the highest artifact proportion is less than 0.5 
        %   3. It rejects IC if Other Proportion is >= 0.20
        if w(p,2)~=1 && w(p,4)/w(p,3)<=0.5 && flag_other == 1
            rej(t,1)=w(p,1);    % Save the index of the rejected IC
            t=t+1;
        end
        end
        EEG_IC = pop_subcomp(EEG_IC, rej, 0); % rejecting IC
        EEG = EEG_IC;
        
        % 7.7) Adding if IC was rejected: 'Yes'/'No' 
        chansremov = ismember(q.w(:,1),rej);
        chs_rmv = {'No', 'Yes'};
        q(:,3) = table(chs_rmv(1+chansremov)');
        
        % 7.8) Saving the ICLabel analysis summary per participant
        q.Properties.VariableNames{'Var2'} = 'Predominant Activity';
        q.Properties.VariableNames{'Var3'} = 'IC Rejected?';
        q = splitvars(q,'w');
        q.Properties.VariableNames{'w_1'} = 'ICs';
        q.Properties.VariableNames{'w_2'} = 'Activity Code';
        q.Properties.VariableNames{'w_3'} = 'Predominant Activity (%)';
        q.Properties.VariableNames{'w_4'} = 'Brain Activity (%)';
        writetable(q,[char(clean_folder), '\',...
        char(table2array(t_subj_code)), '_IC_Discarded.csv']);  
    
        % 7.8) Getting classification percentages AFTER IC rejection
        aux = EEG.etc.ic_classification.ICLabel.classifications;
        if height(array2table(aux)) ~= 1     % If remained componentes are different than 1, then
            t_aux = array2table(mean(aux));  % Average through ICLabel Class
        end
        % Brain and artifact proportions after IC rejection
        t_aux = renamevars(t_aux,t_aux.Properties.VariableNames,...
            EEG_IC.etc.ic_classification.ICLabel.classes);
        % Total of ICs (out of 32) 
        t_IC_total = table(EEG.nbchan - length(idx_bad_chs));
        t_IC_total = renamevars(t_IC_total,t_IC_total.Properties.VariableNames,...
            'Total ICs');
        % Remained ICs after IC rejection
        t_IC_final = table(table2array(t_IC_total) - length(rej));         % Number of ICs rejected out of 32 ICs
        t_IC_final = renamevars(t_IC_final,t_IC_final.Properties.VariableNames,...
            'Remained ICs');
        % Rejected ICs 
        t_IC_rej = table(table2array(t_IC_total) - table2array(t_IC_final));
        t_IC_rej = renamevars(t_IC_rej,t_IC_rej.Properties.VariableNames,...
            'Rejected ICs');        
        % Final table
        brain_perc_clean(i,:) = [t_aux,...
            t_subj_code,t_group, t_IC_total,...
            t_IC_final, t_IC_rej, table(0)];         
    %% 8) Channel Rejection/Interpolation
    table_badname = table2array(bad_chs_all(i,1));                    % Participant code extracted from the table with corrupted channels.
    if strcmp((extractBefore(filename,"_")),char(table_badname)) == 1 % Ensure correspondence between the selected file and the channels to be interpolated
        t_InterChs_num =  array2table(length(idx_bad_chs));           % Number of interpolated channels (out of 32). 
        EEG = pop_interp(EEG, idx_bad_chs, 'spherical');              % NOTE: Excluded channels from ICA weights calculation and interpolated channels must be the same
    else
        finishdlg                                                     % In the event that there is no match
    end
    brain_perc_clean(i,end) = t_InterChs_num;                         % Storing number of interpolated channels
    %% 9) Common Average Reference
    EEG = pop_reref(EEG,[]);    % Common Average Reference
    
    %% 10) Saving Clean [.SET] Files
    pop_saveset(EEG, 'filename', [extractBefore(filename,"Filtered"), 'Clean'],...  
        'filepath', clean_folder);  
    end

    %% 11) Saving Percentages of Brain and Artifacts after IC Rejection
    % Before preprocessing
    brain_perc_route = 'C:\Users\52477\Desktop\UDEM\PEF\EEG';
    brain_perc.Properties.VariableNames = [EEG.etc.ic_classification.ICLabel.classes,...
        {'Participant Code','Group'}];
    writetable(brain_perc,[brain_perc_route, '\',...
        'BrainAndArtifacts_Percent.xlsx'],'Sheet','Before');       
    
    % After preprocessing
    brain_perc_clean.Properties.VariableNames = [EEG.etc.ic_classification.ICLabel.classes,....
        {'Participant Code','Group','Total ICs',...
        'Remained ICs', 'Rejected ICs','Interpolated Channels'}];
    writetable(brain_perc_clean,[brain_perc_route, '\',...
        'BrainAndArtifacts_Percent.xlsx'],'Sheet','After');       
end