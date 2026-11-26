function EEG_Filtering(raw_folder,filt_folder)
for states = 1:length(raw_folder)       % for loop to load raw files in each brach of nested folders
    path = raw_folder{states};          % raw file path of the brach "states"
    raw_files = dir([raw_folder{states} '\*.gdf']); % identifying raw files in the brach "states"
    len1=length(raw_files);             % counting of raw files in branch "states"
    for i = 1:len1
        %% 1) Loading Raw Files [.GDF]
        filename = raw_files(i).name;
        EEG = pop_biosig([path '\' filename]);      % loading EEG raw file
%       EEG.data(:, any(isnan(EEG.data), 1)) = [];  % uncomment this line if the files contain NaN data.
        EEG.times = EEG.times(1:length(EEG.data));  % saving time series of EEG data
        EEG.pnts = length(EEG.data);                % length of each channel
        %% 2) Removing DC offset
        EEG.data = EEG.data - mean(EEG.data,2);     % removing offsett
        filename = extractBefore(filename, '.gdf'); % obtaining filename 
       
        %% 3) Low-pass FIR Filter [30 Hz] 
        EEG = pop_eegfiltnew(EEG,'hicutoff',30,'filtorder',24); 
        
        %% 4 High-pass IIR Filter [1 Hz]
        d = designfilt('highpassiir', ...       % Response type
            'StopbandFrequency',0.01, ...       % Frequency constraints
            'PassbandFrequency',1, ...
            'StopbandAttenuation',60, ...       % Magnitude constraints
            'PassbandRipple',0.1, ...
            'DesignMethod','butter', ...        % Design method
            'MatchExactly','stopband', ...      % Design method options
            'SampleRate',EEG.srate);            % Sample rate
        
        % Applying IIR Filter 
        EEG.data = single(filtfilt(d, double(EEG.data')))';           

        %% 5) Saving Filtered Files [.SET]
         pop_saveset(EEG, 'filename', [filename '_Filtered'],...  
         'filepath', filt_folder{states});
    end
end
end
