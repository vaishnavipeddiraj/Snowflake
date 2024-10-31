GRANT OWNERSHIP ON DATABASE pc_dataiku_db TO ROLE pc_dataiku_role REVOKE CURRENT GRANTS;

use warehouse PC_DATAIKU_WH;
   use database PC_DATAIKU_DB; 
create or replace schema if exists RAW; 
   use schema RAW;

   create or replace table EARNINGS_BY_EDUCATION (
     EDUCATION_LEVEL varchar(100),
     MEDIAN_WEEKLY_EARNINGS_USD decimal(10,2) 
   );

   create or replace table JOB_POSTINGS (
     JOB_ID int,PC_DATAIKU_DB.PUBLIC.JOBS_POSTINGS_JOINEDPC_DATAIKU_DB.PUBLIC.JOBS_POSTINGS_JOINED
     TITLE varchar(200),
     LOCATION varchar(200),
     DEPARTMENT varchar(200),
     SALARY_RANGE varchar(20),
     COMPANY_PROFILE varchar(20000),
     DESCRIPTION varchar(20000),
     REQUIREMENTS varchar(20000),
     BENEFITS varchar(20000),
     TELECOMMUNTING int,
     HAS_COMPANY_LOGO int,
     HAS_QUESTIONS int,
     EMPLOYMENT_TYPE varchar(200),
     REQUIRED_EXPERIENCE varchar(200),
     REQUIRED_EDUCATION varchar(200),
     INDUSTRY varchar(200),
     FUNCTION varchar(200),
     FRAUDULENT int
   );

create or replace file format csvformat
type = csv
field_delimiter =','
field_optionally_enclosed_by = '"', 
skip_header=1;

CREATE OR REPLACE STAGE JOB_DATA
  file_format = csvformat
  url='s3://dataiku-snowflake-labs/data';

CREATE or REPLACE STAGE DATAIKU_DEFAULT_STAGE;
  
 ---- List the files in the stage 

 list @JOB_DATA;

copy into EARNINGS_BY_EDUCATION 
from @JOB_DATA/earnings_by_education.csv
on_error='continue';

copy into JOB_POSTINGS
from @JOB_DATA/job_postings.csv
on_error='continue';

select * from RAW.EARNINGS_BY_EDUCATION limit 10;

select * from RAW.JOB_POSTINGS limit 10;


use schema PUBLIC;

create or replace table JOBS_POSTINGS_JOINED as
select 
    j.JOB_ID as JOB_ID,
    j.TITLE as TITLE,
    j.LOCATION as LOCATION,
    j.DEPARTMENT as DEPARTMENT,
    j.SALARY_RANGE as SALARY_RANGE,
    e.MEDIAN_WEEKLY_EARNINGS_USD as MEDIAN_WEEKLY_EARNINGS_USD,
    j.COMPANY_PROFILE as COMPANY_PROFILE,
    j.DESCRIPTION as DESCRIPTION,
    j.REQUIREMENTS as REQUIREMENTS,
    j.BENEFITS as BENEFITS,
    j.TELECOMMUNTING as TELECOMMUTING,
    j.HAS_COMPANY_LOGO as HAS_COMPANY_LOGO,
    j.HAS_QUESTIONS as HAS_QUESTIONS,
    j.EMPLOYMENT_TYPE as EMPLOYMENT_TYPE,
    j.REQUIRED_EXPERIENCE as REQUIRED_EXPERIENCE,
    j.REQUIRED_EDUCATION as REQUIRED_EDUCATION,
    j.INDUSTRY as INDUSTRY,
    j.FUNCTION as FUNCTION,
    j.FRAUDULENT as FRAUDULENT
from RAW.JOB_POSTINGS j left join RAW.EARNINGS_BY_EDUCATION e on j.REQUIRED_EDUCATION = e.EDUCATION_LEVEL;

select * from PUBLIC.JOB_POSTINGS_JOINED;


grant ALL on all schemas in database PC_DATAIKU_DB to role PC_Dataiku_role;
grant ALL privileges on database PC_DATAIKU_DB to role PC_Dataiku_role;
grant ALL on all stages in database PC_DATAIKU_DB to role PC_Dataiku_role;

alter warehouse PC_DATAIKU_WH set warehouse_size=MEDIUM;
