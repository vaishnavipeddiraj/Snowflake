--Leveraging Query History
SELECT
    query_id,
    query_text,
    user_name,
    query_type,
    start_time
FROM TABLE(information_schema.query_history())
WHERE 1=1
    AND query_type = 'UPDATE'
    AND query_text LIKE '%raw_pos.truck_dev%'
ORDER BY start_time DESC;

--Setting a SQL Variable
SET query_id =
    (
    SELECT TOP 1
        query_id
    FROM TABLE(information_schema.query_history())
    WHERE 1=1
        AND query_type = 'UPDATE'
        AND query_text LIKE '%SET truck_type =%'
    ORDER BY start_time DESC
    );

--Leveraging Time-Travel to Revert our Table
SELECT 
    truck_id,
    make,
    truck_type
FROM raw_pos.truck_dev
BEFORE(STATEMENT => $query_id)
ORDER BY truck_id;


CREATE OR REPLACE TABLE raw_pos.truck_dev
    AS
SELECT * FROM raw_pos.truck_dev
BEFORE(STATEMENT => $query_id); -- revert to before a specified Query ID ran

UPDATE raw_pos.truck_dev t
    SET truck_type = CONCAT(t.year,' ',t.make,' ',REPLACE(t.model,' ','_'));

--Table Swap
USE ROLE accountadmin;
ALTER TABLE raw_pos.truck_dev 
    SWAP WITH raw_pos.truck;

-- Validate Production
SELECT
    t.truck_id,
    t.truck_type
FROM raw_pos.truck t
WHERE t.make = 'Ford';

--Dropping a Table
DROP TABLE raw_pos.truck;

--unDROP TABLE 
UNDROP TABLE raw_pos.truck;

