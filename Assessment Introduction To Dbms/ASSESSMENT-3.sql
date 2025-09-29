CREATE DATABASE IF NOT EXISTS finance;
USE finance;


CREATE TABLE bank(
 branch_id VARCHAR(30) PRIMARY KEY , 
 branch_name VARCHAR(50) NOT NULL, 
 branch_city VARCHAR(30) NOT NULL

);


CREATE TABLE loan (
loan_no VARCHAR(30) PRIMARY KEY,
branch_id VARCHAR(30) NOT NULL,
account_holders_id VARCHAR(30) NOT NULL, 
loan_amount INT ,
loan_type VARCHAR(30)
);


CREATE TABLE account_holder (
account_holders_id  VARCHAR(30) PRIMARY KEY, 
account_no VARCHAR(30) NOT NULL, 
account_holders_name VARCHAR(50) NOT NULL, 
city VARCHAR(30) NOT NULL,
contact VARCHAR(30) NOT NULL, 
date_of_account_created DATE  NOT NULL, 
account_status VARCHAR(30) NOT NULL,  -- (active or terminated) 
account_type VARCHAR(30) NOT NULL, 
balance INT NOT NULL
);


INSERT INTO  bank (branch_id,branch_name,branch_city)
VALUES
("BOB000001","PALADI","AHMEDABAD"),
("BOB000002","VADAJ","AHMEDABAD"),
("BOB000003","ABHILASHA","VADODARA"),
("BOB000004","KARUNA CIRCLE","JAMNAGAR"),
("BOB000005","NIZAMPURA","VADODARA");

INSERT INTO account_holder
(account_holders_id, account_no, account_holders_name, city, contact, date_of_account_created, account_status, account_type, balance)
VALUES
("ACHBOB1","000001","DEV","MORBI","9925617815","2025-04-01","ACTIVE","SAVINGS",40000),
("ACHBOB2","000002","DHRUV","AHMEDABAD","9925617234","2023-07-20","ACTIVE","SAVINGS",60000),
("ACHBOB3","000003","VIVEK","AHMEDABAD","6325417815","2024-03-25","ACTIVE","SAVINGS",38000),
("ACHBOB4","000004","DHARM","JAMNAGAR","6425217715","2016-03-13","ACTIVE","SAVINGS",13000);


INSERT INTO loan (loan_no, branch_id, account_holders_id, loan_amount, loan_type) VALUES
("LN001","BOB000001","ACHBOB1",250000,"HOME"),
("LN002","BOB000002","ACHBOB2",150000,"CAR"),
("LN003","BOB000003","ACHBOB3",50000,"PERSONAL");

--  ################################################################################################

SELECT * FROM account_holder;
SET SQL_SAFE_UPDATES = 0; 

-- 1)
START TRANSACTION;

UPDATE account_holder
SET balance = balance - 100 
WHERE account_no="000002"  ;

UPDATE account_holder
SET balance = balance +100 
WHERE account_no = "000001";

COMMIT;

SELECT * FROM account_holder;

--  ################################################################################################

--  2) fetch the details of the account holder who are related from the same city

SELECT city, account_holders_id, account_holders_name, account_no, balance
FROM account_holder a
WHERE EXISTS (
    SELECT 1 
    FROM account_holder b
    WHERE a.city = b.city 
      AND a.account_holders_id <> b.account_holders_id
);

-- ################################################################################################

 -- 3) Fetch account number and account holder name, 
-- whose accounts were created after 15th of any month
SELECT account_no, account_holders_name, date_of_account_created
FROM account_holder
WHERE DAY(date_of_account_created) > 15;

-- ################################################################################################
-- (4) Display city name and count the branches in that city (alias Count_Branch)
SELECT branch_city AS City, COUNT(branch_id) AS Count_Branch
FROM bank
GROUP BY branch_city;

-- ################################################################################################
-- (5) Display account holder’s id, name, branch id, and loan amount for people who have taken loans (using JOIN)
SELECT ah.account_holders_id, ah.account_holders_name, l.branch_id, l.loan_amount
FROM account_holder ah
JOIN loan l ON ah.account_holders_id = l.account_holders_id;





DROP DATABASE IF EXISTS finance;

