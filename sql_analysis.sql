-- ================================================
-- Project  : Indian Banking Transaction Analytics
-- Author   : Jahnvi Singh
-- Database : banking_project
-- Tool     : MySQL 8.0 + VS Code
-- ================================================
-- Project Setup
--
-- 1. Created the database:
--    CREATE DATABASE banking_project;
--
-- 2. Selected the database:
--    USE banking_project;
--
-- 3. Imported the CSV dataset into MySQL:
--
--    LOAD DATA INFILE
--    'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/indian_banking_transactions.csv'
--    INTO TABLE transactions
--    FIELDS TERMINATED BY ','
--    ENCLOSED BY '"'
--    LINES TERMINATED BY '\n'
--    IGNORE 1 ROWS;
--
-- 4. Connected MySQL Server with VS Code using the MySQL extension.
--
-- 5. Verified successful connection before performing SQL analysis.
--
-- Concepts Covered:
-- Basic SQL | Filtering | Aggregation | GROUP BY | ORDER BY
-- CASE Statements | CTEs | Window Functions | Ranking | Time-Series Analysis



USE banking_project;    


#Basic Analysis
-- B1: Total Number of Transactions
-- Purpose: Count all transactions in the dataset.

SELECT COUNT(*) AS total_transactions
FROM transactions;

-- B2: Total Unique Customers
-- COUNT(DISTINCT) removes duplicate customer IDs before counting.
SELECT COUNT(DISTINCT customer_id) AS total_customers
FROM transactions;

--B3: View sample data
SELECT * FROM transactions LIMIT 10;

-- B4: Total row count
SELECT COUNT(*) AS total_rows FROM transactions;

-- B5: Unique transaction types
SELECT DISTINCT transaction_type FROM transactions;

-- B6: Unique payment channels
SELECT DISTINCT channel FROM transactions;

-- B7: Unique states
SELECT DISTINCT state FROM transactions;

-- B8: View only fraud transactions
SELECT * FROM transactions
WHERE is_fraud = 1
LIMIT 10;

-- B9: Filter by high transaction amount
SELECT * FROM transactions
WHERE transaction_amount > 100000
LIMIT 10;

-- B10: All transactions of a specific customer
SELECT * FROM transactions
WHERE customer_id = 'C1001'
LIMIT 10;

-- B11: Filter by specific date
SELECT * FROM transactions
WHERE transaction_date = '2024-01-01'
LIMIT 10;

--Intermediate Analysis
-- I1: Count of transactions by type
SELECT
    transaction_type,
    COUNT(*) AS total_transactions
FROM transactions
GROUP BY transaction_type
ORDER BY total_transactions DESC;

-- I2: Total amount by payment channel
SELECT
    channel,
    ROUND(SUM(transaction_amount), 2) AS total_amount
FROM transactions
GROUP BY channel
ORDER BY total_amount DESC;

-- I3: Fraud count by state
SELECT
    state,
    SUM(is_fraud) AS total_frauds
FROM transactions
GROUP BY state
ORDER BY total_frauds DESC;


-- I4: Count by KYC status
SELECT
    kyc_status,
    COUNT(*) AS total
FROM transactions
GROUP BY kyc_status;

-- I5: Fraud vs legitimate transaction count
SELECT
    is_fraud,
    COUNT(*) AS total
FROM transactions
GROUP BY is_fraud;

-- I6: Top 5 states by transaction amount
SELECT
    state,
    ROUND(SUM(transaction_amount), 2) AS total_amount
FROM transactions
GROUP BY state
ORDER BY total_amount DESC
LIMIT 5;

-- I7: Average transaction amount by type
SELECT
    transaction_type,
    ROUND(AVG(transaction_amount), 2) AS avg_amount
FROM transactions
GROUP BY transaction_type;

-- I8: Daily transaction count over time
SELECT
    transaction_date,
    COUNT(*) AS daily_transactions
FROM transactions
GROUP BY transaction_date
ORDER BY transaction_date;

--advanced analysis
-- A1: Month-on-Month Growth
--Concept: Window Function, LAG()
SELECT
    YEAR(transaction_date) AS year,
    MONTHNAME(transaction_date) AS month_name,
    SUM(transaction_amount) AS monthly_value,
    LAG(SUM(transaction_amount))
        OVER (ORDER BY YEAR(transaction_date), MONTH(transaction_date)) AS previous_month_value,
    ROUND(
        (SUM(transaction_amount) -
         LAG(SUM(transaction_amount)) OVER (ORDER BY YEAR(transaction_date), MONTH(transaction_date)))
        * 100 /
        LAG(SUM(transaction_amount)) OVER (ORDER BY YEAR(transaction_date), MONTH(transaction_date)),
    2) AS mom_growth_percentage
FROM transactions
GROUP BY YEAR(transaction_date), MONTH(transaction_date), MONTHNAME(transaction_date)
ORDER BY YEAR(transaction_date), MONTH(transaction_date);

-- A2: Fraud Risk Ranking by State
--Concept: CTE + RANK() Window Function
WITH state_fraud AS (
    SELECT
        state,
        COUNT(*) AS total_transactions,
        SUM(is_fraud) AS fraud_transactions,
        ROUND(SUM(is_fraud) * 100.0 / COUNT(*), 2) AS fraud_rate
    FROM transactions
    GROUP BY state
)
SELECT
    state,
    total_transactions,
    fraud_transactions,
    fraud_rate,
    RANK() OVER (ORDER BY fraud_rate DESC) AS risk_rank
FROM state_fraud
ORDER BY risk_rank;

-- A3: High Value Fraud Detection
WITH fraud_summary AS (
    SELECT
        transaction_type,
        channel,
        ROUND(AVG(transaction_amount), 2) AS average_fraud_amount,
        ROUND(MAX(transaction_amount), 2) AS highest_fraud_amount,
        COUNT(*) AS fraud_count
    FROM transactions
    WHERE is_fraud = 1
    GROUP BY transaction_type, channel
)
SELECT *
FROM fraud_summary
ORDER BY fraud_count DESC;

-- A4: KYC Status vs Fraud Rate
SELECT
    kyc_status,
    COUNT(*) AS total_transactions,
    SUM(is_fraud) AS fraud_transactions,
    ROUND(SUM(is_fraud) * 100.0 / COUNT(*), 2) AS fraud_rate_percentage
FROM transactions
GROUP BY kyc_status
ORDER BY fraud_rate_percentage DESC;

--A5: Top 10 Customers by Transaction Amount
SELECT
    customer_id,
    ROUND(SUM(transaction_amount), 2) AS total_transaction_amount,
    COUNT(*) AS total_transactions
FROM transactions
GROUP BY customer_id
ORDER BY total_transaction_amount DESC
LIMIT 10;

-- A6: Fraud Rate by Transaction Type
SELECT
    transaction_type,
    COUNT(*) AS total_transactions,
    SUM(is_fraud) AS fraud_transactions,
    ROUND(SUM(is_fraud) * 100.0 / COUNT(*), 2) AS fraud_rate_percentage
FROM transactions
GROUP BY transaction_type
ORDER BY fraud_rate_percentage DESC;

-- A7: Monthly Fraud Trend
SELECT
    YEAR(transaction_date) AS year,
    MONTHNAME(transaction_date) AS month_name,
    COUNT(*) AS total_transactions,
    SUM(is_fraud) AS fraud_transactions,
    ROUND(SUM(is_fraud) * 100.0 / COUNT(*), 2) AS fraud_rate
FROM transactions
GROUP BY YEAR(transaction_date), MONTH(transaction_date), MONTHNAME(transaction_date)
ORDER BY YEAR(transaction_date), MONTH(transaction_date);

-- A8: Dense Rank Customers by Spending
SELECT
    customer_id,
    ROUND(SUM(transaction_amount), 2) AS total_spending,
    DENSE_RANK()
        OVER (ORDER BY SUM(transaction_amount) DESC) AS spending_rank
FROM transactions
GROUP BY customer_id;

-- A9: Average Transaction Amount by Channel
SELECT
    channel,
    COUNT(*) AS total_transactions,
    ROUND(AVG(transaction_amount), 2) AS average_transaction,
    ROUND(MAX(transaction_amount), 2) AS maximum_transaction,
    ROUND(MIN(transaction_amount), 2) AS minimum_transaction
FROM transactions
GROUP BY channel
ORDER BY average_transaction DESC;

-- A10: Fraud vs Legitimate Transactions
SELECT
    CASE
        WHEN is_fraud = 1 THEN 'Fraud'
        ELSE 'Legitimate'
    END AS transaction_status,
    COUNT(*) AS total_transactions,
    ROUND(AVG(transaction_amount), 2) AS average_amount,
    ROUND(MAX(transaction_amount), 2) AS maximum_amount
FROM transactions
GROUP BY is_fraud;

-- A11: Top States by Fraud Amount
SELECT
    state,
    ROUND(SUM(transaction_amount), 2) AS total_fraud_amount,
    COUNT(*) AS fraud_transactions
FROM transactions
WHERE is_fraud = 1
GROUP BY state
ORDER BY total_fraud_amount DESC;

-- A12: Running Total of Transactions
SELECT
    transaction_date,
    transaction_amount,
    SUM(transaction_amount)
        OVER (ORDER BY transaction_date) AS running_total
FROM transactions
ORDER BY transaction_date;

-- A13: Previous Customer Transaction
SELECT
    customer_id,
    transaction_date,
    transaction_amount,
    LAG(transaction_amount)
        OVER (
            PARTITION BY customer_id
            ORDER BY transaction_date
        ) AS previous_transaction
FROM transactions;


-- A14: Transaction Distribution by Type and Channel
SELECT
    transaction_type,
    channel,
    COUNT(*) AS total_transactions,
    ROUND(AVG(transaction_amount), 2) AS average_transaction_amount,
    ROUND(SUM(transaction_amount), 2) AS total_transaction_amount
FROM transactions
GROUP BY transaction_type, channel
ORDER BY total_transaction_amount DESC;