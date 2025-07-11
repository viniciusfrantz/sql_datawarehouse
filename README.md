## Project Data Engineering and Analytics pipeline

### Data Warehouse for Sales Analytics
#### About this project
I built this project using modern data engineering tools to integrate different sales data sources into a single, reliable warehouse. My goal was to create clean and organized data that’s ready for analysis and helps drive better business decisions.

### Tools & Skills
- dbt: Data modeling, transformation, documentation, and quality checks
- SQL: Data extraction, cleaning, and transformation queries
- PostgreSQL: Database design, implementation, and optimization
- Git: Version control for code and data pipeline scripts
- Data Engineering: ETL pipeline development, medallion architecture, star schema design
- Data Integration: Combining multiple data sources into a unified warehouse

## Integrating Sales Systems to provide Data ready for querying 

### Building the Data Warehouse

- The project uses 2 sources of data, the ERP and CRM systems. The master system is CRM. The data is provided as CSV files.
- Automated ETL pipelines with dbt models, ensuring scalable and maintainable code
- The project will use the medallion architecture, using the 3 layers: Bronze, Silver and Gold.
- **Bronze Layer**: The data will be loaded as-is
- **Silver Layer**: Cleaning, standardization and normalization to prepare data for analysis.
- **Gold Layer**: Preparation of data marts and business-focused tables.

<div align="center">
<img src="./Images/vinicius_dwh_project.jpg"  alt="Integration Model" width="600"/>
</div>

## 01. Bronze Layer
- Creating the database and schemas.
```
    - |scripts/00_db_schemas.sql
```
- Creating Bronze Layer
- Analyzing Source Systems
    - Business Context & Ownership
    - Architecture & Technology Stack: Postgres, Medallion 
    - Extract & Load: Full loads        
- Coding for data ingestion: DDL and load
```
    - |Scripts/01_1_ddl_bronze.sql
    - |scripts/01_2_proc_load_bronze.sql
```
- Validating: Data completeness & schema checks
```
    - |Scripts/01_3_quality_checks_bronze.sql
```
- Documentation: Data versioning in git

#### Integrating DBT:

- Created a new schema [src_schema_bronze.yml] to use as a "source" and documentation in dbt

_____________________
## 02. Silver Layer
The goal of this layer:

- Understand How the tables connect to each other. To do this, a data integration model was created using 6 source tables, identifying keys that link each table.

<div align="center">
    <img src="./Images/integration_model.jpg" alt="Integration Model" width="500"/>
</div>

### Scripts to construct, clean, standardize, normalize each table:
```
- |scripts\02_silver
    - |4_1_checks_silver_crm_cust_info.sql
    - |04_2_checks_silver_crm_prd_info.sql
    - |04_3_checks_silver_crm_sales_details.sql
    - |04_4_checks_silver_erp_az212.sql
    - |04_5_checks_silver_erp_loc_a101.sql
    - |04_06_checks_silver_erp_px_cat_g1v2.sql
```

### DBT - Silver models by source
```
- dbt_datawarehouse\models\silver
    - \crm
        - |crm__cust_info.sql
        - |crm__prd_info.sql
        - |crm__sales_details.sql
        - |schema_crm_silver.yml
    - \erp
        - |erp__cust_az12.sql
        - |erp__loc_a101.sql
        - |erp__px_cat_g1v2.sql
        - |schema_erp_silver.yml
```
________________

## 03. Gold Layer

- Dimension Table
    - dim_products
    - dim_customers

- Fact Table
    - crm_sales_details

- Star Schema
- Aggregated objects
- Flat tables

### DBT - Gold models
```
- dbt_datawarehouse\models\gold
    - |dim_customers.sql
    - |dim_products.sql
    - |fact_sales.sql
    - |schema_gold.yml
```

## Final Dbt Lineage Graph

<div align="center">
    <img src="./Images/dbt_lineage_graph_layers.jpg" alt="DBT Lineage Graph" width="800"/>
</div>

____________________________

## SALES Schema - Star Schema ERD  (Gold Layer)

```mermaid
erDiagram
    DIM_CUSTOMERS {
        integer customer_id PK "Primary Key"
        string customer_key
        string first_name
        string last_name
        string country
        string marital_status
        string gender
        date birth_date
        date create_date
    }

    DIM_PRODUCTS {
        integer product_id PK "Primary Key"
        string product_key
        string category_id
        string product_name
        string category
        string subcategory
        string maintenance
        string product_line
        float product_cost
        date product_start_date
        date product_end_date
    }

    FACT_SALES {
        string order_number PK "Primary Key"
        integer customer_id FK "FK to DIM_CUSTOMERS"
        integer product_id FK "FK to DIM_PRODUCTS"
        date order_date
        date ship_date
        date due_date
        integer quantity
        float price
        float sales_amount
    }

    FACT_SALES }|--|| DIM_CUSTOMERS : "customer_id"
    FACT_SALES }|--|| DIM_PRODUCTS : "product_id"
```