# Banking-Fraud-Analytics

## About This Project

India processes billions of banking transactions every year across UPI, NEFT, RTGS, IMPS, and card networks. As digital payments have grown, so have fraud risks, failed transactions, and data quality issues that make it harder for regulators and analysts to get a clear picture of what is actually happening on the ground.

This project is my attempt to build a complete, end-to-end analytics pipeline on a real-world Indian banking transactions dataset. I did this independently to strengthen my data analytics skills and to create portfolio work that is relevant to banking and financial regulation contexts.

Starting from a raw, messy dataset, I cleaned and validated the data, ran exploratory analysis, wrote SQL queries for deeper insights, automated an MIS report in Excel, and built a Power BI dashboard that a non-technical stakeholder can actually read and use.

## Problem Statement

Indian banking data is rarely clean, rarely simple, and rarely tells you what you need to know without some digging. Transaction volumes vary wildly across channels and bank categories. Fraud patterns are buried in the noise. Reporting is often manual and inconsistent.

The goal of this project was to cut through that and answer a few core questions:

- How have digital payment channels grown over time, and which ones are driving volume vs value?
- Where is fraud risk concentrated, and what transaction patterns are associated with it?
- Can the reporting process be automated so analysts spend less time formatting and more time analysing?

## What I Did

**Data Cleaning (Python / pandas):**
Took the raw dataset, fixed missing values, removed duplicates, corrected data types, standardised inconsistent entries, and documented every single cleaning decision.

**Exploratory Data Analysis (Python):**
Analysed transaction trends across payment channels, bank categories, and time. Visualised fraud distribution, failure rates, and volume-value gaps.

**SQL Analysis:**
Wrote queries using CTEs and window functions to calculate year-on-year growth, rank channels by performance, and identify fraud concentration by segment.

**MIS Automation (openpyxl):**
Built a script that auto-generates a formatted monthly MIS Excel report from the cleaned dataset, no manual work needed.

**Power BI Dashboard:**
Designed an interactive dashboard covering digital payment trends, fraud risk indicators, and channel-level performance. Built for a non-technical, senior stakeholder audience.

## Tools Used

Python, pandas, numpy, matplotlib, seaborn, SQL, Power BI, Excel, openpyxl


