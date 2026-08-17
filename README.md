# EEG_Preprocessing

******************* **ENGLISH** *******************

This repository contains an EEG preprocessing pipeline divided into two MATLAB functions:

**EEG_Filtering.m**: applies the first part of the preprocessing:
  * Load raw files [.gdf format] 
  * DC offset removal
  * Band-pass filtering
  * Save filtered files [.set format]

**Preprocessing_EEG.m**: applies the remainder of the preprocessing pipeline.
 1) Remove Channel Drift by ASR 
 2) Identifying Bad Channels to Ignore them in ICA
 3)  ICA Weights
 4)  ICLabel
 5)  Channel Rejection/Interpolation
 6)  Common Average Reference
 7)  Saving CLEAN .Set File
 8)  Saving Percentages of Brain and Artifacts Activities

**The instrucions for using both scripts are described below:**

- **Step 1**: Running _EEG_Filtering.m_
   - For the function _EEG_Filtering(path_raw, path_filtered)_, configure input data as follows:
     - _path_raw_: path from folder/nested folders where raw data is imported. For nested folders, _path_raw_ must be a [CELL] containing all folder paths. Each path must be [CHAR]. Otherwise, use _path_raw_ = "your path" as [STRING]
     - _path_filtered_: path from folder/nested folders where filtered data will be exported. For nested folders, _path_filtered_ must be a [CELL] containing all folder paths. Each path must be [CHAR]. Otherwise, use _path_filtered_ = "your path" as [STRING]

- **Step 2**: EEG signal manual inspection for non-cerebral segment rejection.

- **Step 3**: Running _Preprocessing_EEG.m_
  - For the function _[brain_perc,brain_perc_clean]=Preprocessing_EEG(path_filtered, path_clean_all);_
    - **INPUT DATA**
      - _path_filtered_: path from folder/nested folders where filtered data is imported.
      - _path_clean_all_: path from folder/nested folders where clean data will be exported.
    - **OUTPUT DATA**
      - _brain_perc_: neural data percentage **before** preprocessing [DOUBLE]
      - _brain_perc_clean_: neural data percentage **after** preprocessing [DOUBLE] 
