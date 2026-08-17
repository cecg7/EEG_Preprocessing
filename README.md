# EEG_Preprocessing

******************* **ENGLISH** *******************

This repository contains an EEG preprocessing pipeline divided into two MATLAB functions:

**EEG_Filtering.m**: applies the first part of the preprocessing:
  * Load raw files [.gdf format] 
  * DC offset removal
  * Band-pass filtering
  * Save filtered files [.set format]

**Preprocessing_EEG.m**: applies the remainder of the preprocessing pipeline.

[LIST ALL STEPS HERE]

- Step 1: Running **EEG_Filtering.m**
   - For the function _EEG_Filtering(path_raw, path_filtered)_, configure input data as follows:
     - To import raw files from nested folders _path_raw_ must be a [CELL] containing all folder paths. Each path must be [CHAR]. Otherwise, use _path_raw_ = "your path". "Your path" must be [STRING]
     - To export filtered data to nested folders, _path_filtered_ must be a [CELL] containing all folder paths. Each path must be [CHAR]. Otherwise, use _path_filtered_ = "your path". "Your path" must be [STRING]

- Step 2: EEG signal manual inspection for non-cerebral segment rejection.

- Step 3: Running **Preprocessing_EEG.m**
  - For the function _[brain_perc,brain_perc_clean]=Preprocessing_EEG(path_filtered, path_clean_all);_
   - **INPUT DATA**
    - _path_filtered_: path from folder/nested folders where filtered data is imported.
    - _path_clean_all_: path from folder/nested folders where clean data will be exported.
   - **OUTPUT DATA**
    - _brain_perc_: neural data percentage **before** preprocessing [DOUBLE]
    - _brain_perc_clean_: neural data percentage **after** preprocessing [DOUBLE] 
