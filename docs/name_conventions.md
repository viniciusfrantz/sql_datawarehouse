## Name Conventions

## General
Naming conventions: Use snake_case
Language: English for all names
Avoid Reserved words: Do not use SQL reserved words as object names

## Table Naming Conventions

### Bronze Rules
- All names must start with the source system name, separeted with double underscor and table names must match their original names without renaming;
- e.g.: <source_system>__<table_name>
    - <sourcesystem>: e.g.: crm, erp
    - <table_name>: table name from source system
    - Example: crm__customer_info

### Silver Rules
    - Same rules from Bronze

### Gold Rules
- All names must be meaningful, starting with category prefix
    - <category>_<entity>

    Categories:
    - dim
    - fact
    - agg
    - scd

## Column Naming Conventions:
### Surrogate Keys
- All primary keys in dimension tables must use the suffix _key
- <table_name>_key
- Example: customer_key

### Technical Columns
- All columns with metadata, must start with dwh_, followed by a descriptive name indicating the column's purpose.
- dwh_<column_name>
    - dwh_: prefix exclusive for system-generated metadata
    - <column_name>: Descriptive indicatind column's purpose
    - Example: dwh_load_tade

### Stored procedure
- All stored procedure used for loading data must follow the naming pattern:
- load<layer>
    -<layer>: represents the layer being loaded
    - Example:
        - load_bronze: Stored procedure for loading data into the bronze layer

