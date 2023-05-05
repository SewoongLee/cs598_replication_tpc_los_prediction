Code for Patient Length of Stay (LoS) Prediction in the Intensive Care Unit (ICU) with Temporal Pointwise Convolutional (TPC) Networks.
===============================

## Citation to the original paper
 - https://dl.acm.org/doi/abs/10.1145/3450439.3451860

## Link to the original paper’s repo
 - https://github.com/EmmaRocheteau/TPC-LoS-prediction

## Dependencies
 - Python 3.6
 - Pandas 0.24.2
 
## Data download instruction
### eICU
 - eICU database set up: https://physionet.org/content/eicu-crd/2.0/. 
 - MIMIC-IV database set up: https://physionet.org/content/mimiciv/0.4/. 

## Preprocessing code + command
### eICU

1) Follow the instructions: https://eicu-crd.mit.edu/tutorials/install_eicu_locally/ to ensure the correct connection configuration. 

2) Replace the eICU_path in `paths.json` to a convenient location in your computer, and do the same for `eICU_preprocessing/create_all_tables.sql` using find and replace for 
`'/Users/emmarocheteau/PycharmProjects/TPC-LoS-prediction/eICU_data/'`. Leave the extra '/' at the end.

3) In your terminal, navigate to the project directory, then type the following commands:

    ```
    psql 'dbname=eicu user=eicu options=--search_path=eicu'
    ```
    
    Inside the psql console:
    
    ```
    \i eICU_preprocessing/create_all_tables.sql
    ```
    
    This step might take a couple of hours.
    
    To quit the psql console:
    
    ```
    \q
    ```
    
4) Then run the pre-processing scripts in your terminal. This will need to run overnight:

    ```
    python3 -m eICU_preprocessing.run_all_preprocessing
    ```
    
### MIMIC-IV

1) The official recommended way to access MIMIC-IV is via BigQuery: https://mimic-iv.mit.edu/docs/access/bigquery/. Personally I did not find it easy to store the necessary views and there is a 1GB size limit on the data you can download in the free tier, which is less than I am using here (the largest file to extract is timeseries.csv which is 4.49GB). However if you do wish to use BigQuery, note that you will have to make minor modifications to the code e.g. you would need to replace a reference to the table `patients` with `physionet-data.mimic_core.patients`. 
    
    Alternatively, you can follow instructions to set up the full database. The instructions for the previous version of MIMIC - MIMIC-III are here: https://mimic.physionet.org/tutorials/install-mimic-locally-ubuntu/ for unix systems or: https://mimic.physionet.org/tutorials/install-mimic-locally-windows/ for windows. You will need to change `mimiciii` schema to `mimiciv` and use the files in: https://github.com/EmmaRocheteau/MIMIC-IV-Postgres in place of the files in: https://github.com/MIT-LCP/mimic-code/tree/master/buildmimic/postgres (referenced in the instructions). Additionally you may find this resource helpful: https://github.com/MIT-LCP/mimic-iv/tree/master/buildmimic/postgres which is still in the process of being updated (as of November 2020).

2) Once you have a database connection, replace the MIMIC_path in `paths.json` to a convenient location in your computer, and do the same for `MIMIC_preprocessing/create_all_tables.sql` using find and replace for 
`'/Users/emmarocheteau/PycharmProjects/TPC-LoS-prediction/MIMIC_data/'`. Leave the extra '/' at the end.

3) If you have set up the database on your local computer, you can navigate to the project directory in your terminal, then type the following commands:

    ```
    psql 'dbname=mimic user=mimicuser options=--search_path=mimiciv'
    ```
    
    Inside the psql console:
    
    ```
    \i MIMIC_preprocessing/create_all_tables.sql
    ```
    
    This step might take a couple of hours.
    
    To quit the psql console:
    
    ```
    \q
    ```
    
4) Then run the pre-processing scripts in your terminal. This will need to run overnight:

    ```
    python3 -m MIMIC_preprocessing.run_all_preprocessing
    ```

## Training/Evaluation code + command
### Our Descriptive Jupyter Notebook for Project Summary, Visualization, and Illustration
 - [main/summary_notebook.ipynb](https://github.com/SewoongLee/cs598_replication_tpc_los_prediction/blob/main/summary_notebook.ipynb).


## Table of results

Model | Average LoS Error
--- | ---
TPC | 1.7
TPC (MSE) | 2.8
TPC (No Skip Connection) | 1.95
Temporal Only | 2.46
Pointwise Only | 2.87
LSTM | 2.88
Transformer | 2.88
Human (Clinicians) | 3.82
