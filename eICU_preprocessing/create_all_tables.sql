-- creates all the tables and produces csv files
-- takes a while to run (about an hour)

-- change the paths to those in your local computer using find and replace for 'D:/datasets/eicu/'.
-- keep the file names the same

\i eICU_preprocessing/labels.sql
\i eICU_preprocessing/diagnoses.sql
\i eICU_preprocessing/flat_features.sql
\i eICU_preprocessing/timeseries.sql

-- we need to make sure that we have at least some form of time series for every patient in diagnoses, flat and labels
drop materialized view if exists ld_timeseries_patients cascade;
create materialized view ld_timeseries_patients as
  with repeats as (
    select distinct patientunitstayid
      from ld_timeserieslab
    union
    select distinct patientunitstayid
      from ld_timeseriesresp
    union
    select distinct patientunitstayid
      from ld_timeseriesnurse
    union
    select distinct patientunitstayid
      from ld_timeseriesperiodic
    union
    select distinct patientunitstayid
      from ld_timeseriesaperiodic)
  select distinct patientunitstayid
    from repeats;

\copy (select * from ld_labels as l where l.patientunitstayid in (select * from ld_timeseries_patients)) to 'D:/datasets/eicu/labels.csv' with csv header
\copy (select * from ld_diagnoses as d where d.patientunitstayid in (select * from ld_timeseries_patients)) to 'D:/datasets/eicu/diagnoses.csv' with csv header
\copy (select * from ld_flat as f where f.patientunitstayid in (select * from ld_timeseries_patients)) to 'D:/datasets/eicu/flat_features.csv' with csv header
\copy (select * from ld_timeserieslab) to 'D:/datasets/eicu/timeserieslab.csv' with csv header
\copy (select * from ld_timeseriesresp) to 'D:/datasets/eicu/timeseriesresp.csv' with csv header
\copy (select * from ld_timeseriesnurse) to 'D:/datasets/eicu/timeseriesnurse.csv' with csv header
\copy (select * from ld_timeseriesperiodic) to 'D:/datasets/eicu/timeseriesperiodic.csv' with csv header
\copy (select * from ld_timeseriesaperiodic) to 'D:/datasets/eicu/timeseriesaperiodic.csv' with csv header