# EEG Pipeline Description

This repository contains an EEG preprocessing pipeline consisting of two MATLAB functions developed using the EEGLAB plugin. The pipeline primarily uses ICLabel to identify and remove artifact-related independent components. Its main purpose is to quantify the percentage of neuronal activity retained in the EEG recordings before and after preprocessing, allowing assessment of artifact removal's effect on the resulting signals.

Before running the pipeline, the user must create a predefined nested folder structure for loading and saving EEG files. The folder structure separates **raw**, **filtered**, and **clean** EEG files according to (1) recording condition and (2) study group. The user must also configure the corresponding folder paths within the MATLAB functions according to their local directory structure. The following provides an example of the required data organization:

- **Step 1**: Configure Nested Folders.
Suppose baseline and activity are recording conditions across both experimental and control groups. Thus, nested folder paths must be configured as:
    - **Raw data**
        + _.../raw/baseline/experimental_
        + _.../raw/baseline/control_
        + _.../raw/activity/experimental_
        + _.../raw/activity/control_
    - **Filtered data**
        + _.../filtered/baseline/experimental_
        + _.../filtered/baseline/control_
        + _.../filtered/activity/experimental_
        + _.../filtered/activity/control_
    - **Clean data**
        + _.../clean/baseline/experimental_
        + _.../clean/baseline/control_
        + _.../clean/activity/experimental_
        + _.../clean/activity/control_

- **Step 2**: Running _EEG_Filtering.m_
Raw data are loaded into the _EEG_filtering.m_ function. The resulting filtered files are then saved in their corresponding folder. The filtering process is described below:

    - **EEG_Filtering.m**
        - 1) Load raw files [.gdf format]
        - 2) DC offset removal
        - 3) Low-pass FIR Filter [30 Hz]
        - 4) High-pass IIR Filter [1 Hz]
        - 5) Save filtered files [.set format]

     - **Input Data: EEG_Filtering(_path_raw_,_path_filtered_)**
       + _path_raw_: path from folder/nested folders where raw data is imported. For nested folders, _path_raw_ must be a [CELL] containing all folder paths. Each path must be [CHAR]. Otherwise, use _path_raw_ = "your path" as [STRING]
       + _path_filtered_: path from folder/nested folders where filtered data will be exported. For nested folders, _path_filtered_ must be a [CELL] containing all folder paths. Each path must be [CHAR]. Otherwise, use _path_filtered_ = "your path" as [STRING]

- **Step 3**: Manual inspection must be performed after running the `EEG_Filtering.m` function. During this process, identify and manually reject transient artifacts, and detect corrupted channels for subsequent removal or interpolation. Mark corrupted channels with "1" in the _channel_interpolation.xlsx_ file

- **Step 4**: Running _IC_MARBLE.m_
Filtered data are loaded into the  _IC_MARBLE.m_ function. The resulting clean files are then saved in their corresponding folder. The remainder of the preprocessing pipeline is described below:

    - **IC_MARBLE.m**:
        - 1) Loading filtered [.set] files
        - 2) Remove channel drift by Artifact Subspace Reconstruction [0.25-0.75 Hz]
        - 3) Specify the corrupted channels to exclude them from the ICA weights calculation
        - 4) ICA Weights
        - 5) $\color{red}ICLabel$
        - 6) Saving Percentages of Brain and Artifacts **before** IC Rejection
        - 7) Automatic IC rejection
        - 8) Channel Rejection/Interpolation
        - 9) Common Average Reference
        - 10) Saving Clean [.set] Files
        - 11) Saving Percentages of Brain and Artifacts **after** IC Rejection

        - **Input Data:** [brain_perc,brain_perc_clean]=IC_MARBLE(**path_filtered, path_clean_all**)
            + _path_filtered_: path to the folder/nested folders where filtered data is imported.
            + _path_clean_all_: path to the folder/nested folders where clean data will be exported.
        - **Output Data:** [**brain_perc,brain_perc_clean**]=IC_MARBLE(path_filtered, path_clean_all)
            + _brain_perc_: neural data percentage **before** preprocessing [DOUBLE]
            + _brain_perc_clean_: neural data percentage **after** preprocessing [DOUBLE] 
