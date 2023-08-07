# pay_buddy

Introduction to the project

Hi and welcome to this practice dbt project. 

This README file will walk you through the steps taken in creating a data model for fictional BNPL payment service Pay Buddy. 

1. Purpose of the project

- The overall goal is to answer potential business questions pertaining to Pay Buddy's activity
- In order to do this, let's explore the data modeling functionalities offered by dbt (data build tool)
- Since it is much more enjoyable in terms of developer experience and debugging capabilities, this is a functional dbt project based on a connection to a gcp bucket. 
- Thus, the SQL code is based on the BigQuery syntax

2. Business concept and questions

PayBuddy is an e-commerce platform offering payment solutions to merchants allowing buyers to purchase goods and repay at a later date. 

PayBuddy pays the merchant immediately and collects the payment from the buyer once the due date has been reached. 

To determine a buyer’s eligibility, PayBuddy runs a credit assessment based on payment plans generated for each specific merchant. Payment plans have a duration of 30 or 60 days. 

If the credit assessment is successful, the buyer is presented with one or multiple payment plan options. 

Pay Buddy’s revenue comes from fees paid by the merchants based on the value of each purchase facilitated.  


The stakeholder persona for this project is defined as the Head of Revenue Management.

They are interested in questions such as:
- Percentage of accepted/rejected orders
- Number and Value of accepted orders
- Total Revenue by merchant
- Outstanding Amount by Buyer

3. High level model

Two flows can be identified from the business model:

Merchant flow: a merchant receives payment plan templates from Pay Buddy and signs an agreement to be able to offer these payment plans in exchange for a fee. Fees are issued if an order is accepted. 

Buyer flow: a buyer receives payment plan proposals from a merchant upon completing an order. Pay Buddy's decision engine reviews the buyer profile and approves one or multiple payment plans if conditions are met. An invoice is generated based on the payment plan selected by the buyer. Repayment is due at the end of the term specified by the payment plan. 

4. Information necessary to answer the questions:

- an order table containing total order value and order approval status for each order_id
- a merchant fee table containing the fees generated for each merchant_id
- a buyer invoice table containing the outstanding amounts for each buyer_id

5. Data Modeling Plan
In order to build the analytical tables, the raw tables provided must be cleaned, joined, and aggregated as part of a dbt project. 

The project will contain:
- a staging layer to perform basic cleaning and harmonization of the raw source tables
- an intermediate layer to perform necessary joins for some of the staging tables
- an analytical layer containing fact and dimension tables 

