/* ==========================================================================
   lab6_backup.sql
   CIS 4720 Database Management and SQL

   WHAT THIS FILE IS
   This rebuilds everything in_class_lab6 asked you to build, so that whatever
   happened in the lab, you now have the same working database as everyone
   else. The lab PCs are wiped every night, which is why the database you
   built last time is not there any more. A script like this one is the real
   answer to that problem: the file is the database, and the server is
   disposable.

   WHAT IT BUILDS
     1. A schema called cis4720_yourname
     2. One table, PRODUCT, with five columns and a primary key
     3. Four rows of data
     4. One view, PRODUCT_PRICES, showing only the name and the price

   The extra credit from lab6 is deliberately NOT in here.

   HOW TO RUN IT
   Open it in VS Code with SQLTools connected, then run it one statement at a
   time, or run the whole file. Lab7 walks you through it.

   READ THIS BEFORE YOU RUN IT A SECOND TIME
   Run it once and everything works. Run it twice and you will get errors,
   because the table already exists and the rows are already there. Lab7
   explains which parts to comment out and why.
   ========================================================================== */


-- ======================================================================
-- SECTION 1. The schema
-- A schema is the container that holds your tables. CREATE DATABASE makes
-- one, and USE tells the server which one the following statements apply to.
-- ======================================================================

-- Create the schema. IF NOT EXISTS means this line is safe to run twice.
CREATE DATABASE IF NOT EXISTS cis4720_yourname;

-- Switch into it. Everything below lands inside this schema.
USE cis4720_yourname;


-- ======================================================================
-- SECTION 2. The table
-- Each column gets a data type that fits what it holds:
-- INT           whole numbers, used here for the id
-- VARCHAR(40)   text up to 40 characters
-- DECIMAL(7,2)  a number with exactly 2 decimal places, correct for money
-- DATE          a real date, stored as YYYY-MM-DD
-- NOT NULL means the column may never be left empty.
-- PRIMARY KEY means prod_id must be unique and may never be empty.
-- ======================================================================

CREATE TABLE PRODUCT (
    prod_id     INT          NOT NULL,
    prod_name   VARCHAR(40)  NOT NULL,
    unit_price  DECIMAL(7,2),
    added_on    DATE,
    roast_level VARCHAR(10),
    PRIMARY KEY (prod_id)
);


-- ======================================================================
-- SECTION 3. The data
-- Four rows. In lab6 you added the first three by hand, then Antigua Classic
-- came later. The roast_level column was added with ALTER TABLE in lab6 and
-- is simply part of the table here.
-- ======================================================================

INSERT INTO PRODUCT VALUES (1,'Yirgacheffe',    18.50,'2026-01-15','Light');
INSERT INTO PRODUCT VALUES (2,'Huila Supremo',  15.25,'2026-03-02','Medium');
INSERT INTO PRODUCT VALUES (3,'Cerrado Daily',  12.60,'2026-05-20','Medium');
INSERT INTO PRODUCT VALUES (4,'Antigua Classic',16.80,'2026-07-04','Medium');


-- ======================================================================
-- SECTION 4. The view
-- A view is a stored SELECT statement that you can query as if it were a
-- table. This one shows only the name and the price, so anyone using it
-- cannot reach the id, the date or the roast level.
-- ======================================================================

CREATE VIEW PRODUCT_PRICES AS
SELECT prod_name, unit_price
FROM PRODUCT;


-- ======================================================================
-- SECTION 5. Checks
-- These only read. They are safe to run as many times as you like, so leave
-- them uncommented even after the first run.
-- ======================================================================

-- All four rows, straight from the table.
SELECT * FROM PRODUCT;

-- The view, most expensive first. Two columns, not five.
SELECT * FROM PRODUCT_PRICES ORDER BY unit_price DESC;

-- Should come back as 4 products and 63.15.
SELECT COUNT(*) AS products, SUM(unit_price) AS total_price FROM PRODUCT;

-- PRODUCT is a BASE TABLE and PRODUCT_PRICES is a VIEW. SHOW TABLES on its
-- own does not tell them apart, which is why this one says FULL.
SHOW FULL TABLES;


-- ######################################################################
-- YOUR LAB7 WORK STARTS BELOW THIS LINE
--
-- Add your Chapter 5 statements under the headings below, in order. Put a
-- comment above every statement saying what it does, in your own words.
-- The comments are graded.
-- ######################################################################


-- STEP 10. Section 5.1, look at your schema
--schema holds tables, a container for my tables 
SELECT DATABASE() AS my_schema;
SHOW FULL TABLES;
-- STEP 11. Section 5.2, look at the data types
--data types is what kind of data stored in each column
--results in the fields and type of data it is suchas integer or date.
--prod id is an integer bc no decimals, prod name isvarchar which is the limit of characters, unit price is decimal because it is money, added on is date so it can sort it properly, and roast level is up to 10 characters.
DESCRIBE PRODUCT;

-- STEP 12. Section 5.3, create a table by copying with a subquery
--making a table out of select statement,  it shows the copy of the table created
CREATE TABLE PRODUCT_COPY AS
SELECT prod_id, prod_name, unit_price
FROM PRODUCT;

SELECT * FROM PRODUCT_COPY;

SHOW CREATE TABLE PRODUCT_COPY;
-- STEP 13. Section 5.4, change the structure of the copy
--adds a new column  to show if product is on sale
ALTER TABLE PRODUCT_COPY ADD COLUMN on_sale CHAR(1);
--alter_table is used to change the structure and make colum wider
ALTER TABLE PRODUCT_COPY MODIFY COLUMN prod_name VARCHAR(60) NOT NULL;
--adds primary key back to the copy table
ALTER TABLE PRODUCT_COPY ADD PRIMARY KEY (prod_id);
--describe shows structure of table and the data types
DESCRIBE PRODUCT_COPY;
--returns error error since primary key was already in use
INSERT INTO PRODUCT_COPY VALUES (1,'Duplicate',9.99,NULL);
--removes column that added to the copy table
ALTER TABLE PRODUCT_COPY DROP COLUMN on_sale;
-- STEP 14. Section 5.5, insert, update and delete a row
--adds a new row to table named kenya peaberry with price 21.40
INSERT INTO PRODUCT_COPY VALUES (5,'Kenya Peaberry',21.40);
SELECT * FROM PRODUCT_COPY WHERE prod_id = 5;
--changes row in table to update the price to 22.95
UPDATE PRODUCT_COPY SET unit_price = 22.95 WHERE prod_id = 5;
SELECT * FROM PRODUCT_COPY WHERE prod_id = 5;
--removes that row from table
DELETE FROM PRODUCT_COPY WHERE prod_id = 5;
SELECT * FROM PRODUCT_COPY WHERE prod_id = 5;

-- STEP 15. Section 5.6, create a view and update through it
--two rows come backunder 16.00
CREATE VIEW CHEAP_PRODUCTS AS
SELECT prod_id, prod_name, unit_price
FROM PRODUCT_COPY
WHERE unit_price < 16.00;

SELECT * FROM CHEAP_PRODUCTS;

--before
SELECT prod_id, unit_price FROM PRODUCT_COPY WHERE prod_id = 3;
--update names view 
UPDATE CHEAP_PRODUCTS SET unit_price = 13.99 WHERE prod_id = 3;

--after changes the price of the product with prod_id 3 to 13.99
SELECT prod_id, unit_price FROM PRODUCT_COPY WHERE prod_id = 3;

/*CREATE VIEW PRICE_SUMMARY AS
SELECT COUNT(*) AS n, SUM(unit_price) AS total
FROM PRODUCT_COPY;
UPDATE PRICE_SUMMARY SET total = 99; /*

-- doesnt show the total because it is a view and not a table