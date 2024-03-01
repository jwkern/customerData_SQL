/*______________________________________________________________________________
CODE DESCRIPTION: 

This SQL code (customerData_JWK.sql) calculates the profit margin of a fictitious
dataset of customer transactions. The data for the card, transaction, and customer 
are stored in separate databases which also include the store and card type which 
are stored in small master databases. The revenue of each transaction is logged as 
well as the cost of the product(s) sold. This is used to calculate the profit 
margin and other metrics of the dataset.  

Written by: Joshua W. Kern
Date: 03/01/24                                                                  
________________________________________________________________________________*/

/*______________________________________________________________________________
Step 0: Initialize the database
________________________________________________________________________________*/
DROP DATABASE IF EXISTS Misc;
CREATE DATABASE Misc;
USE Misc;



/*______________________________________________________________________________
Step 1: Initialize the data tables
________________________________________________________________________________*/
CREATE TABLE stores(
	id INT,
	address TEXT,
	city TEXT,
	state TEXT,
	country TEXT,
	zipcode TEXT,
	PRIMARY KEY (id)
);


CREATE TABLE card_type(
        id INT,
        card_type TEXT,
        PRIMARY KEY (id)
);


CREATE TABLE customers(
        id INT,
        zipcode TEXT,
        state TEXT,
        country TEXT,
        first_name TEXT,
        last_name TEXT,
	store_id INT,
       	PRIMARY KEY (id)
);


CREATE TABLE card_number(
        id INT,
	card_number TEXT,
	customer_id INT,
	card_type_id INT,
	PRIMARY KEY (id)
);


CREATE TABLE card_transactions(
        id INT,
        date DATE,
        card_number_id INT,
        revenue FLOAT,
        cost FLOAT,
        PRIMARY KEY (id)
);


/*______________________________________________________________________________
Step 2: Load the data into the tables
________________________________________________________________________________*/
LOAD DATA LOCAL INFILE '/home/jwkern/Downloads/stores.csv' REPLACE INTO TABLE stores FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 rows;
LOAD DATA LOCAL INFILE '/home/jwkern/Downloads/card_type.csv' REPLACE INTO TABLE card_type FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 rows;
LOAD DATA LOCAL INFILE '/home/jwkern/Downloads/card_transactions.csv' REPLACE INTO TABLE card_transactions FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 rows;
LOAD DATA LOCAL INFILE '/home/jwkern/Downloads/card_number.csv' REPLACE INTO TABLE card_number FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 rows;
LOAD DATA LOCAL INFILE '/home/jwkern/Downloads/customers.csv' REPLACE INTO TABLE customers FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 rows;




/*______________________________________________________________________________
Step 3: Select subset of data and calculate properties
_______________________________________________________________________________*/
CREATE TABLE profitTransactions AS SELECT MONTH(date) AS month, 
				YEAR(date) AS year, 
				(revenue - cost) AS profit,
				card_number.customer_id AS customer_id,
				card_number.id AS card_id
FROM card_transactions
RIGHT JOIN card_number 
ON card_transactions.card_number_id = card_number.id;


CREATE TABLE monthlyProfit AS 
SELECT year,
       month,
       ROUND(SUM(profit),2) AS profit
FROM profitTransactions
GROUP BY year, month
ORDER BY year, month;


CREATE TABLE monthlyTransactions AS  
SELECT EXTRACT(YEAR FROM date) AS year,
       EXTRACT(MONTH FROM date) AS month,
       COUNT(revenue) AS sales,
       ROUND(SUM(revenue),2) AS revenue,
       ROUND(SUM(cost),2) AS cost
FROM card_transactions
GROUP BY EXTRACT(YEAR FROM date), EXTRACT(MONTH FROM date)
ORDER BY EXTRACT(YEAR FROM date) ASC, EXTRACT(MONTH FROM date);


CREATE TABLE monthlySummary AS
SELECT monthlyTransactions.year, monthlyTransactions.month, monthlyTransactions.sales, monthlyTransactions.revenue, monthlyTransactions.cost, monthlyProfit.profit
FROM monthlyTransactions
RIGHT JOIN monthlyProfit
ON monthlyTransactions.month = monthlyProfit.month;


SELECT * 
FROM monthlySummary
ORDER BY month
INTO OUTFILE '/var/lib/mysql-files/monthlySummary.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

/*______________________________________________________________________________
________________________________________________________________________________

--------------------------------------------------------------------------------
-----------------------------------THE END--------------------------------------
--------------------------------------------------------------------------------
________________________________________________________________________________
________________________________________________________________________________*/

