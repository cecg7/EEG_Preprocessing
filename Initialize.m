%% 1) Start EEGLab
addpath('Insert EEGLab plugin path here');
addpath('Insert main folder path here');
eeglab()
%% 2) Defining the working directories
% Insert Nested Folders you need - Raw Data
F1 = 'Insert Path 1 here';
F2 = 'Insert Path 2 here';
F3 = 'Insert Path 3 here';
raw_folder = {F1, F2, F3};
% Insert Nested Folders you need - Filtered Data
F1 = 'Insert Path 1 here';
F2 = 'Insert Path 2 here';
F3 = 'Insert Path 3 here';
filt_folder = {F1, F2, F3};
% Insert Nested Folders you need - Clean Data
F1 = 'Insert Path 1 here';
F2 = 'Insert Path 2 here';
F3 = 'Insert Path 3 here';
clean_folder = {F1, F2, F3};

%% Filtering Function
Filtering(raw_folder,filt_folder); 
% Load raw data from raw_folder paths and save filtered data in filt_folder paths

%% Preprocessing Pipeline
[brain_perc,brain_perc_clean]=IC_MARBLE(filt_folder{x},clean_folder{x}); 
% Load filtered data from filt_folder{x} path and save clean data in clean_folder{x} path.
% Replace "x" for an integer 
