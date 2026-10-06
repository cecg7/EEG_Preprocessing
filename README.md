# EEG_Preprocessing

******************* **ENGLISH** *******************

This repository contains an EEG preprocessing pipeline consisting of two MATLAB functions designed with the EEGLab plugin. Both functions works by arranging EEG files within nested folders. Nested folders were intended to separate **raw**, **filtered**, and **clean** EEG files according to each 1) recording condition and 2) study group. The following provides an example of how the data should be organized:

- **Step 1**: Configure Nested Folders.
Suppose baseline and activity as recording conditions across both experimental and control groups. Thus, nested folders paths must be configured as:
* **Raw data**
 * _.../raw/baseline/experimental_
 * _.../raw/baseline/control_
 * _.../raw/activity/experimental_
 * _.../raw/activity/control_
* **Filtered data**
 * _.../filtered/baseline/experimental_
 * _.../filtered/baseline/control_
 * _.../filtered/activity/experimental_
 * _.../filtered/activity/control_
* **Clean data**
 * _.../clean/baseline/experimental_
 * _.../clean/baseline/control_
 * _.../clean/activity/experimental_
 * _.../clean/activity/control_

- **Step 2**: Running _EEG_Filtering.m_
After that, the raw data are loaded into the _EEG_filtering.m_ function. The resulting filtered files are then saved in their corresponding folder. The filtering process is described below:

- **EEG_Filtering.m**:
  * Load raw files [.gdf format] 
  * DC offset removal
  * Low-pass FIR Filter [30 Hz]
  * High-pass IIR Filter [1 Hz]
  * Save filtered files [.set format]

     - For the function _EEG_Filtering(path_raw, path_filtered)_, configure input data as follows:
     - _path_raw_: path from folder/nested folders where raw data is imported. For nested folders, _path_raw_ must be a [CELL] containing all folder paths. Each path must be [CHAR]. Otherwise, use _path_raw_ = "your path" as [STRING]
     - _path_filtered_: path from folder/nested folders where filtered data will be exported. For nested folders, _path_filtered_ must be a [CELL] containing all folder paths. Each path must be [CHAR]. Otherwise, use _path_filtered_ = "your path" as [STRING]



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

- **Step 2**: Manual inspection must be performed prior to running the `EEG_preprocessing.m` function. During this inspection, transient artifacts should be identified and rejected, and corrupted channels should be identified for subsequent removal or interpolation. Use _channel_interpolation.xlsx_ file to report corrupted channels in each EEG file

- **Step 3**: Running _Preprocessing_EEG.m_
  - For the function _[brain_perc,brain_perc_clean]=Preprocessing_EEG(path_filtered, path_clean_all);_
    - **INPUT DATA**
      - _path_filtered_: path from folder/nested folders where filtered data is imported.
      - _path_clean_all_: path from folder/nested folders where clean data will be exported.
    - **OUTPUT DATA**
      - _brain_perc_: neural data percentage **before** preprocessing [DOUBLE]
      - _brain_perc_clean_: neural data percentage **after** preprocessing [DOUBLE] 
