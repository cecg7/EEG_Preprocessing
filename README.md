# EEG_Preprocessing

******************* **ENGLISH** *******************

This repository contains an EEG preprocessing pipeline divided into two MATLAB functions:
- **EEG_Filtering.m**: applies the first part of the preprocessing:
  * Load raw files [.gdf format] 
  * DC offset removal
  * Band-pass filtering
  * Save filtered files [.set format]
- **EEG_Preprocessing.m**: applies the remainder of the preprocessing pipeline.
[LIST ALL STEPS HERE]


- Step 1: Running **EEG_Filtering.m**
For the function _EEG_Filtering(path_raw, path_filtered)_, configure input data as follows:
- _path_raw_ is a [STRUCT] including the folder paths where raw files are imported. Use _path_raw_ = "your path" if you have only one folder path. 
- _path_filtered_ is a [STRUCT] including the folder paths where filtered files are exported. Use _path_filtered_ = "your path" if you have only one folder path.

Step 2: Running **EEG_Preprocessing.m**
