# Table of contents
1. [Introduction](# pay_buddy)
2. [Purpose of the project](## 1. Purpose of the project)
3. [Business concept and questions](## 2. Business concept and questions)

# pay_buddy

Hi and welcome to this practice dbt project. 

This README file will walk you through the journey of creating a data model for fictional BNPL (buy now, pay later) payment service Pay Buddy. 

## 1. Purpose of the project

- The overall goal is to answer business questions related to Pay Buddy's activity
- In order to do this, let's explore the data modeling functionalities offered by dbt (data build tool)
- Since it is much more enjoyable in terms of developer experience and debugging capabilities, this is a        functional dbt project connected to a GCP bucket. 

## 2. Business concept and questions

Pay Buddy is an e-commerce payment solutions enabling merchants to receive payments right away, while allowing buyers to pay at a later date. It aims to solve cash flow issues for merchants, remove friction due to unpaid orders, and unlock sales that would otherwise have been lost. 
 
The stakeholder persona for this project is defined as the Head of Revenue Management.

They are interested in questions such as:
- Mix of accepted/rejected orders
- Volume of accepted orders (total and value)
- Total Revenue made by Pay Buddy on each merchant
- Outstanding Amount for each buyer

## 3. High level model

Two flows can be identified from the business model:

Merchant flow: a merchant receives payment plan templates from Pay Buddy and signs an agreement to be able to offer these payment plans in exchange for a fee. Fees are issued if an order is accepted. 

Buyer flow: a buyer receives payment plan proposals from a merchant upon completing an order. Pay Buddy's decision engine reviews the buyer's profile and approves one or multiple payment plans if conditions are met. An invoice is generated based on one of the accepted payment plans, for which repayment is due at the end of the imparted term. 

4. Information necessary to answer the questions:

- an order table containing total order value and order approval status for each order_id
- a merchant fee table containing the fees generated for each merchant_id
- a buyer invoice table containing the outstanding amounts for each buyer_id

## 5. Data Modeling Plan
In order to build the analytical tables, the raw tables provided must be cleaned, joined, and aggregated as part of a dbt project. 

The project will contain:
- a staging layer to perform basic cleaning and harmonization of the raw source tables
- an intermediate layer to perform necessary joins for some of the staging tables
- an analytical layer containing aggregated information for high level business entities (i.e. buyer, merchant, order, invoice, fee, payment plan) 

### Staging layer:

- the main goal is to harmonize the column names to make them as clear as possible to a business user
- Dates need to be modified to match the SQL date format. Due to the clustering of dates, this model is built on the assumption that they are in the DD/MM/YYYY format. 
- some foreign keys don't match the format of the primary key in the source table (i.e. payment_plan_id in raw invoice table, agreement_id in raw payment plan template table)

### Intermediate layer:

- the purpose of this table is to create modular elements to be reused further downstream in order to avoid repeating code
- some logic is abstracted to produce higher level objects based on functional units (e.g. invoices and repayments, payment plans, payment plan templates, and agreements)
- this would have been the location to implement currency conversion. Since all payments provided in the sample data are in GBP, currency conversion was not implemented in this model. This is a tradeoff to limit complexity, which should ideally be implemented using an API connection to retrieve daily exchange rates. 

### Analytical layer:

- this layer contains tables that can be used to answer business questions either via simple SQL queries, a metrics store, or a BI tool. 
- the goal was to limit the number of joins needed to a data consumer or an API to retrieve information. 
- as it stands, the 'buyers' and 'merchants' tables sit at the top of the model, and can be used to answer precise questions about buyer and merchant activity
- alternatively, the 'fees', 'invoices', and 'orders' tables can be used to answer questions for specific periods of time. 
- the 'payment plans' table contains higher level logic about the Pay Buddy decision engine

## 6. Queries to answer questions: 

### QUESTION ONE Percentage of accepted/rejected orders:

either:

```SQL
SELECT 
SUM(total_accepted_orders) / SUM(total_orders) AS percentage_accepted_orders,
SUM(total_refused_orders) / SUM(total_orders) AS percentage_refused_orders,
FROM `pay-buddy-dbt-project.pay_buddy_schema.buyers` 
```
or

```SQL
SELECT 
SUM(total_accepted_orders) / SUM(total_orders) AS percentage_accepted_orders,
SUM(total_refused_orders) / SUM(total_orders) AS percentage_refused_orders,
FROM `pay-buddy-dbt-project.pay_buddy_schema.merchants`
```
or

```SQL
SELECT 
COUNT(DISTINCT IF(is_accepted, order_id, NULL)) / COUNT(DISTINCT order_id) AS percentage_accepted_orders,
COUNT(DISTINCT IF(NOT is_accepted, order_id, NULL)) / COUNT(DISTINCT order_id) AS percentage_refused_orders
FROM `pay-buddy-dbt-project.pay_buddy_schema.orders`
```
the latter is markedly more complex for a non technical user, but is necessary when adding time filters or grouping by date. 
(running all three is also a way to perform QA)

### QUESTION TWO Number and Value of accepted orders:

either 

```SQL
SELECT 
SUM(total_accepted_orders) total_accepted_orders,
SUM(total_accepted_order_amount) AS total_accepted_order_amount
FROM `pay-buddy-dbt-project.pay_buddy_schema.buyers` 
```
or

```SQL
SELECT 
SUM(total_accepted_orders) total_accepted_orders,
SUM(total_accepted_order_amount) AS total_accepted_order_amount
FROM `pay-buddy-dbt-project.pay_buddy_schema.merchants`
```
or 

```SQL
SELECT 
COUNT(DISTINCT IF(is_accepted, order_id, NULL)) AS total_accepted_orders,
SUM(IF(is_accepted, order_amount,0)) AS total_accepted_order_amount
FROM `pay-buddy-dbt-project.pay_buddy_schema.orders`
```
here also, the latter query is necessary when adding time filters or grouping by date. 
(running all three is also a way to perform QA)

### QUESTION THREE Total Revenue by merchant:

```SQL
SELECT 
merchant_id
, total_accepted_order_amount -- value of sold inventory
, lifetime_value -- value to Pay Buddy
FROM `pay-buddy-dbt-project.pay_buddy_schema.merchants`
ORDER BY 3 DESC 
```
### QUESTION FOUR Outstanding Amount by Buyer:

```SQL
SELECT 
buyer_id
, total_outstanding_amount
FROM `pay-buddy-dbt-project.pay_buddy_schema.buyers`
WHERE TRUE AND total_outstanding_amount > 0
ORDER BY 2 DESC 
```