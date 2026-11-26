%% 1) Start EEGLab
addpath('C:\Program Files\MATLAB\R2020a\eeglab2024.2');
addpath('C:\Users\52477\Desktop\UDEM\PEF\EEG');
eeglab()
%% 2) Defining the working directories
% Nested Folders - Raw Data
F1 = 'C:\Users\52477\Desktop\UDEM\PEF\EEG\Raw\Folder1';
F2 = 'C:\Users\52477\Desktop\UDEM\PEF\EEG\Raw\Folder2';
F3 = 'C:\Users\52477\Desktop\UDEM\PEF\EEG\Raw\Folder3';
raw_folder = {F1, F2, F3};
% Nested Folders - Filtered Data
F1 = 'C:\Users\52477\Desktop\UDEM\PEF\EEG\Filtered\Folder1';
F2 = 'C:\Users\52477\Desktop\UDEM\PEF\EEG\Filtered\Folder2';
F3 = 'C:\Users\52477\Desktop\UDEM\PEF\EEG\Filtered\Folder3';
filt_folder = {F1, F2, F3};
% Nested Folders - Clean Data
F1 = 'C:\Users\52477\Desktop\UDEM\PEF\EEG\Clean\Folder1';
F2 = 'C:\Users\52477\Desktop\UDEM\PEF\EEG\Clean\Folder2';
F3 = 'C:\Users\52477\Desktop\UDEM\PEF\EEG\Clean\Folder3';
clean_folder = {F1, F2, F3};

%% Filtering Function
Filtering(raw_folder,filt_folder);

%% Preprocessing Pipeline
[brain_perc,brain_perc_clean]=IC_MARBLE(filt_folder{1},clean_folder{1});

%%
[brain_perc,brain_perc_clean]=Preprocessing_EEG_01(filt_folder{1},clean_folder{1});
