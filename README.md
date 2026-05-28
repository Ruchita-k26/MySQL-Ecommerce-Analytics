## Project Overview

This project is an end-to-end SQL and ETL project built using the Brazilian E-commerce dataset in MySQL. The main goal of this project was to understand how raw real-world data is imported, structured, and analyzed inside a relational database.

In this project, I created multiple relational tables, loaded large CSV datasets into MySQL, established primary and foreign key relationships, and performed SQL analysis on customer behavior, orders, products, sellers, and payments.

The project also involved handling several practical database challenges during data import and transformation. Instead of using simple import methods, I worked with bulk loading techniques using LOAD DATA INFILE, optimized imports for large datasets, and solved multiple issues related to datetime conversion, encoding, MySQL security restrictions, and datatype mismatches.

## Dataset Description

The project uses the Brazilian E-commerce Public Dataset by Olist. The dataset contains information about nearly 100,000 e-commerce orders placed in Brazil between 2016 and 2018.

The dataset includes multiple connected tables such as:

Customers  
Orders  
Products  
Sellers  
Payments  
Reviews  
Geolocation  
Product category translations  

These tables represent a complete e-commerce ecosystem and allow analysis of customer behavior, seller performance, delivery trends, product categories, revenue, and reviews.

The dataset also contains real-world inconsistencies like different datetime formats, encoding problems, and missing records in some columns, making it useful for practicing practical SQL and ETL concepts.

## Tools Used
MySQL Server 8.0  
MySQL Workbench  
CSV datasets  

## Problems Faced and Solutions Implemented

#### 1. Slow CSV Import Using MySQL Workbench
##### Problem
Initially, I used the MySQL Workbench Import Wizard to import CSV files. Since the dataset contained thousands of rows, the import process became very slow and inefficient.
##### Solution
To improve performance, I switched to using:
LOAD DATA INFILE
This method imported large datasets much faster and became the primary loading method for the project.

#### 2. LOCAL INFILE Disabled Error
##### Problem
While using LOAD DATA INFILE, MySQL generated an error because local file loading was disabled for security reasons.
##### Solution
I enabled the setting manually using:
SET GLOBAL local_infile = 1;
I also updated MySQL Workbench connection settings by enabling:
OPT_LOCAL_INFILE = 1
inside the Advanced connection configuration.

#### 3. secure-file-priv Restriction
##### Problem
MySQL only allowed imports from a secure folder and rejected CSV files stored in other locations such as Downloads or project directories.
##### Solution
I moved all dataset files into the MySQL Uploads folder:
C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/
After moving the files, MySQL successfully loaded the datasets.

#### 4. Datetime Conversion Errors
##### Problem
Several datasets contained date values in text format, which caused errors while importing into DATETIME columns.
##### Solution
I used:
STR_TO_DATE()
to convert string values into proper MySQL DATETIME format during data loading and updates.

#### 5. Blank Datetime Values
##### Problem
Some rows contained empty datetime fields, which caused conversion failures during import.

##### Solution
I handled empty values safely using:
NULLIF()
This converted blank values into SQL NULL before applying datetime conversion.

#### 6. Incorrect Integer and Decimal Value Errors
##### Problem
Some numeric columns contained empty strings or invalid values, which caused import failures for INT and DECIMAL columns.
##### Solution
I solved this issue using:
CAST()
along with NULLIF() to safely convert numeric values during import.

#### 7. UTF-8 Encoding Problems
##### Problem
Some city names and review texts appeared corrupted because of character encoding mismatches.
##### Solution
I fixed the issue by adding:
CHARACTER SET utf8mb4
inside the import queries to properly support UTF-8 characters.

#### 8. Windows Line Ending Issues
##### Problem
Some CSV files contained Windows line endings (\r\n) which caused hidden formatting problems during import.
##### Solution
I changed:
LINES TERMINATED BY '\n'
to:
LINES TERMINATED BY '\r\n'
which correctly handled the CSV file formatting.

#### 9. Table Relationship Management
##### Problem
While creating relationships between tables, foreign key constraints sometimes caused import issues because referenced data was not loaded yet.
##### Solution
I imported data first and added primary keys and foreign keys afterward to avoid dependency conflicts during loading.

#### 10. Understanding Real-World ETL Challenges
##### Problem
The raw datasets were not perfectly clean and required multiple rounds of debugging before successful import.
##### Solution
I used Excel and SQL queries to inspect the data, identify inconsistencies, and gradually clean and transform the datasets before analysis.

