--create a clone of production

USE ROLE tb_dev;
USE DATABASE tb_101;
CREATE OR REPLACE TABLE raw_pos.truck_dev CLONE raw_pos.truck;

--Querying our Cloned Table
USE WAREHOUSE tb_dev_wh;
SELECT
    t.truck_id,
    t.year,
    t.make,
    t.model
FROM raw_pos.truck_dev t
ORDER BY t.truck_id;

--Using Persisted Query Results
SELECT
    t.truck_id,
    t.year,
    t.make,
    t.model, --> Snowflake supports Trailing Comma's in SELECT clauses
FROM raw_pos.truck_dev t
ORDER BY t.truck_id;

--Updating Incorrect Values in a Column
UPDATE raw_pos.truck_dev 
    SET make = 'Ford' WHERE make = 'Ford_';

--Constructing our Truck Type Column
SELECT
    truck_id,
    year,
    make,
    model,
    CONCAT(year,' ',make,' ',REPLACE(model,' ','_')) AS truck_type
FROM raw_pos.truck_dev;

--Adding a Column
ALTER TABLE raw_pos.truck_dev 
    ADD COLUMN truck_type VARCHAR(100);

--Updating our Column
UPDATE raw_pos.truck_dev
    SET truck_type =  CONCAT(year,make,' ',REPLACE(model,' ','_'));

--Querying our new Column
SELECT
    truck_id,
    year,
    truck_type
FROM raw_pos.truck_dev
ORDER BY truck_id;

