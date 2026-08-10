# EEG_Preprocessing

******************* **ENGLISH** *******************

This repository contains  an EEG preprocessing pipeline divided into two files:
- **EEG_Filtering.m**: applies the first part of the preprocessing: 
  * DC offset removal
  * Band-pass filtering
- **EEG_Preprocessing.m**: applies the remainder of the preprocessing pipeline.
[LIST ALL STEPS HERE]

Step 1: Running **EEG_Filtering.m**
For the function _EEG_Filtering(path_raw, path_filtered)_, configure input data as follows:
- _path_raw_ is the path where raw files are imported
- _path_filtered_ is the path where filtered files are exported

REVISAR SI SE DEBEN IMPORTAR EN GDF O SET
