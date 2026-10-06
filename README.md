# EEG_Preprocessing

******************* **ENGLISH** *******************

This repository contains an EEG preprocessing pipeline consisting of two MATLAB functions designed with the EEGLab plugin. Both functions work by organizing EEG files into nested folders. Nested folders were intended to separate **raw**, **filtered**, and **clean** EEG files according to each 1) recording condition and 2) study group. The following provides an example of how the data should be organized:

- **Step 1**: Configure Nested Folders.
Suppose baseline and activity are recording conditions across both experimental and control groups. Thus, nested folder paths must be configured as:
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
Raw data are loaded into the _EEG_filtering.m_ function. The resulting filtered files are then saved in their corresponding folder. The filtering process is described below:

- **EEG_Filtering.m**:
  * Load raw files [.gdf format] 
  * DC offset removal
  * Low-pass FIR Filter [30 Hz]
  * High-pass IIR Filter [1 Hz]
  * Save filtered files [.set format]

     - For the function _EEG_Filtering(path_raw, path_filtered)_, configure input data as follows:
     - _path_raw_: path from folder/nested folders where raw data is imported. For nested folders, _path_raw_ must be a [CELL] containing all folder paths. Each path must be [CHAR]. Otherwise, use _path_raw_ = "your path" as [STRING]
     - _path_filtered_: path from folder/nested folders where filtered data will be exported. For nested folders, _path_filtered_ must be a [CELL] containing all folder paths. Each path must be [CHAR]. Otherwise, use _path_filtered_ = "your path" as [STRING]

- **Step 3**: Manual inspection must be performed after running the `EEG_Filtering.m` function. During this process, identify and manually reject transient artifacts, and detect corrupted channels for subsequent removal or interpolation. Mark the corrupted channels with "1" in the _channel_interpolation.xlsx_ file

- **Step 4**: Running _Preprocessing_EEG.m_
Filtered data are loaded into the  _Preprocessing_EEG.m_ function. The resulting clean files are then saved in their corresponding folder. The remainder of the preprocessing pipeline is described below:

**Preprocessing_EEG.m**:
 1) Remove Channel Drift by ASR [0.25-0.75 Hz]
 2) Specify the corrupted channels to exclude them from the ICA weight calculation
 4) ICA Weights
 5) ICLabel
 6) Saving Percentages of Brain and Artifacts **before** IC Rejection
 7) Automatic IC rejection
 8) Channel Rejection/Interpolation
 9) Common Average Reference
 10) Saving CLEAN .Set File
 11) Saving Percentages of Brain and Artifacts **after** IC Rejection

  - For the function _[brain_perc,brain_perc_clean]=Preprocessing_EEG(path_filtered, path_clean_all);_
    - **INPUT DATA**
      - _path_filtered_: path from folder/nested folders where filtered data is imported.
      - _path_clean_all_: path from folder/nested folders where clean data will be exported.
    - **OUTPUT DATA**
      - _brain_perc_: neural data percentage **before** preprocessing [DOUBLE]
      - _brain_perc_clean_: neural data percentage **after** preprocessing [DOUBLE] 
