___________________________________________________________________________________________________________________________________________________________________
___________________________________________________________________________________________________________________________________________________________________
___________________________________________________________________________________________________________________________________________________________________
# customerData_SQL

___________________________________________________________________________________________________________________________________________________________________
GENERAL DESCRIPTION:
This SQL script uses five related spreadsheets of financial information (e.g. card type, transactions, customer info, etc.) to calculate profit margins and other relevant metrics.
___________________________________________________________________________________________________________________________________________________________________
DATA DESCRIPTION:
In this example, the financial data being used has been generated partly from the online source https://generate-random.org/person-identity-generator. 

An example schema of each of the dataframes are given below: 
      
      stores(
              id INT,
              address TEXT,
              city TEXT,
              state TEXT,
              country TEXT,
              zipcode TEXT,
              PRIMARY KEY (id))
            
      card_type(
              id INT,
              card_type TEXT,
              PRIMARY KEY (id))
            
      customers(
              id INT,
              zipcode TEXT,
              state TEXT,
              country TEXT,
              first_name TEXT,
              last_name TEXT,
              store_id INT,
              PRIMARY KEY (id))
        
      card_number(
              id INT,
              card_number TEXT,
              customer_id INT,
              card_type_id INT,
              PRIMARY KEY (id))
      
      card_transactions(
              id INT,
              date DATE,
              card_number_id INT,
              revenue FLOAT,
              cost FLOAT,
              PRIMARY KEY (id))



___________________________________________________________________________________________________________________________________________________________________
CODE DESCRIPTION:
This SQL code (customerData_JWK.sql) imports financial data for three months of transactions at various company locations. The script uses the individual transactions to calculate the profit margin and other metrics.  


___________________________________________________________________________________________________________________________________________________________________
RUNNING THE CODE:
1) Download the data (stores.csv, card_type.csv, card_transactions.csv, customers.csv, card_number.csv) as well as the SQL script (customerData_JWK.sql)

2) In a terminal, cd into the directory that now contains the data and the script

3) In customerData_JWK.sql, change the file path on lines 79 - 83 from "/home/jwkern/Downloads/" to point to your local directory containing the data files 

4) Run the script by typing the following into the command line:

            mysql --local-infile=1 -u username -p password < customerData_JWK.sql

  (P.S. don't forget to change the username and password to your mySQL credentials)

5) The output is saved in your secure-file-priv location, or in another directory which could be specified on line 131


___________________________________________________________________________________________________________________________________________________________________
___________________________________________________________________________________________________________________________________________________________________
___________________________________________________________________________________________________________________________________________________________________
