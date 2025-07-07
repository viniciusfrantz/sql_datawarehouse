/*
DDL to create tables in Bronze layer
This script create all tables to bronze Layer, in accordance with the sources, without transformation, just load like it-is

/*### Bronze Rules
- All names must start with the source system name, separeted with double underscor and table names must match their original names without renaming;
- e.g.: <source_system>__<table_name>
    - <sourcesystem>: e.g.: crm, erp
    - <table_name>: table name from source system
    - Example: crm__customer_info*/

-- Creating table how it is


-- crm> cust_info
-- cst_id,cst_key,cst_firstname,cst_lastname,cst_marital_status,cst_gndr,cst_create_date
-- 11000,AW00011000, Jon,Yang ,M,M,2025-10-06

--CREATE OR REPLACE TABLE bronze.crm__cust_info ( --SNOWFLAKE)
DROP TABLE IF EXISTS bronze.crm__cust_info;
CREATE TABLE bronze.crm__cust_info(
    cst_id INT,
    cst_key VARCHAR(50),
    cst_first_name VARCHAR(50),
    cst_lastname VARCHAR(50),
    cst_marital_status VARCHAR(15),
    cst_gndr VARCHAR(15),
    cst_create_date DATE
);


--prd_id,prd_key,prd_nm,prd_cost,prd_line,prd_start_dt,prd_end_dt
-- 210,CO-RF-FR-R92B-58,HL Road Frame - Black- 58,,R ,2003-07-01,
DROP TABLE IF EXISTS bronze.crm__prd_info;
CREATE TABLE bronze.crm__prd_info (
    prd_id INT,
    prd_key VARCHAR(30),
    prd_nm VARCHAR(50),
    prd_cost FLOAT,
    prd_line VARCHAR(50),
    prd_start_dt DATE,
    prd_end_dt DATE
);


-- sls_ord_num,sls_prd_key,sls_cust_id, sls_order_dt, sls_ship_dt, sls_due_dt, sls_sales, sls_quantity,sls_price
-- SO43697, BK-R93R-62, 21768, 20101229, 20110105, 20110110, 3578, 1, 3578
DROP TABLE IF EXISTS bronze.crm__sales_details;
CREATE TABLE bronze.crm__sales_details(
    sls_ord VARCHAR(20),
    sls_prd_key VARCHAR(20),
    sls_cust_id INT,
    sls_order_dt INT,
    sls_ship_dt INT,
    sls_due_dt INT,
    sls_sales FLOAT,
    sls_quantity INT,
    sls_price FLOAT
);


-- CID,BDATE,GEN
-- NASAW00011000,1971-10-06,Male
DROP TABLE IF EXISTS bronze.erp__cust_az12;
CREATE TABLE bronze.erp__cust_az12(
    cid VARCHAR(30),
    bdate DATE,
    gen VARCHAR(20)
);


--   CID,CNTRY
-- AW-00011000,Australia
DROP TABLE IF EXISTS bronze.erp__loc_a101;
CREATE TABLE  bronze.erp__loc_a101(
    cid VARCHAR(30),
    cntry VARCHAR(30)
);


-- ID,CAT,SUBCAT,MAINTENANCE
-- AC_BR,Accessories,Bike Racks,Yes
DROP TABLE IF EXISTS bronze.erp__px_cat_g1v2;
CREATE TABLE bronze.erp__px_cat_g1v2(
    id VARCHAR(20),
    cat VARCHAR(50),
    subcat VARCHAR(50),
    maintenence VARCHAR(30)
);
