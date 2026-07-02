# Insurance Semantic Layer Project

## Overview

This project demonstrates the implementation of a semantic layer for an insurance analytics use case using **dbt**, **DuckDB**, and **Cube.js**.

The objective was to transform raw insurance datasets into business-ready analytical models and expose trusted business metrics that can be consumed consistently by reporting and BI tools.

The project follows a layered architecture consisting of:

- Raw Data
- Staging Layer
- Mart Layer
- Semantic Layer

---

# Technology Stack

| Component | Technology |
|-----------|------------|
| Database | DuckDB |
| Transformation | dbt |
| Semantic Layer | Cube.js |
| Source Data | CSV Files |

---

# Dataset

The project uses four source datasets.

- Customers
- Policies
- Claims
- Transactions

These datasets are loaded into DuckDB using dbt seeds.

---

# Project Structure

```
rbc_project/

│
├── dbt_project.yml
├── profiles.yml
│
├── seeds/
│     raw_customers.csv
│     raw_policies.csv
│     raw_claims.csv
│     raw_transactions.csv
│
├── models/
│
│     staging/
│        stg_customers.sql
│        stg_policies.sql
│        stg_claims.sql
│        stg_transactions.sql
|        semantic_layer - Schema
│
│     marts/
│        dim_customers.sql
│        dim_policies.sql
│        fact_claims.sql
│        fact_transactions.sql
│        mart_policy_performance.sql
|        semantic_layer - Schema
│
├── cube/
│     schema/
│        Policies.js
│        .env
│        cube.js
│
└── README.md
```

---

# Data Modeling Approach

## Staging Layer

The staging layer is responsible for preparing raw data for downstream models.

Activities performed:

- Standardized column names
- Converted dates into proper date format
- Removed unnecessary transformation logic from marts
- Maintained one staging model per source dataset

Models created:

- stg_customers
- stg_policies
- stg_claims
- stg_transactions

---

## Mart Layer

The mart layer contains business-ready models.

Dimension Models

- dim_customers
- dim_policies

Fact Models

- fact_claims
- fact_transactions

Business Mart

- mart_policy_performance

The business mart combines policy, customer, claims and transaction information into a single analytical model for reporting.

---

# Business Metrics

The semantic layer exposes the following business metrics.

### Active Policies

Number of active insurance policies.

---

### Total Premium Collected

Sum of completed premium transactions.

---

### Total Claims Paid

Sum of settlement amount for settled claims.

---

### Claim Count

Total number of claims.

---

### Average Settlement Days

Average number of days required to settle a claim.

---

### Loss Ratio

Loss Ratio =

Claims Paid

/

Premium Collected

---

# Business Dimensions

The semantic layer exposes the following dimensions.

Customer

- Customer Name
- Customer Segment
- State

Policy

- Policy Type
- Policy Status
- Coverage Amount

Claim

- Claim Category
- Claim Status

Time

- Policy Start Date
- Claim Date
- Settlement Date

---

# dbt Tests

Implemented tests include:

### Not Null

- Customer ID
- Policy ID
- Claim ID
- Transaction ID

### Unique

- Customer ID
- Policy ID
- Claim ID
- Transaction ID

---

# Assumptions

The following assumptions were used while building the solution.

- Only transactions with status **Completed** contribute towards premium collected.
- Only claims with status **Settled** contribute towards claims paid.
- Loss Ratio is calculated only when premium collected is greater than zero.
- One customer can own multiple policies.
- One policy can have multiple claims.
- One policy can have multiple premium transactions.

---

# Sample Business Questions Supported

The semantic model supports answering questions such as:

- How many active policies do we currently have?
- What is the total premium collected?
- What is the total amount paid in claims?
- Which policy type has the highest loss ratio?
- What is the average claim settlement time?
- Premium collected by customer segment
- Claims by policy type
- Claims by state

---

# Running the Project

## Load Seed Data

```
dbt seed
```

## Build Models

```
dbt run
```

## Execute Tests

```
dbt test
```

---

# Cube.js

Cube.js semantic models have been created for:

- Policies
- Claims
- Transactions

The semantic models expose reusable business metrics and dimensions that can be consumed by BI tools without rewriting SQL.

---

# Design Decisions

A layered architecture was chosen to separate responsibilities.

**Staging Layer**

Responsible only for data standardization and cleaning.

**Mart Layer**

Responsible for business logic and metric calculations.

**Semantic Layer**

Responsible for providing a reusable business definition of metrics and dimensions so that reporting tools use a consistent source of truth.

This approach keeps transformation logic independent from reporting logic and allows metrics to be reused across multiple dashboards.

---

# Future Enhancements

Some enhancements that could be added if this solution were extended further include:

- Relationship tests between dimensions and facts
- Accepted value tests for status fields
- Incremental dbt models
- Cube pre-aggregations for improved query performance
- Row-level security
- Additional insurance KPIs
- Time intelligence metrics (YTD, MTD, Rolling 12 Months)
- Automated data quality monitoring
- CI/CD deployment pipeline

---

# Notes

The dbt implementation was completed successfully using DuckDB, including seed loading, staging models, mart models, tests, and business metric calculations.

Cube.js semantic model files are included to show how the metrics and dimensions would be exposed to downstream reporting tools. I encountered a local DuckDB connectivity issue while running Cube.js on Windows, so this would be the next item I would troubleshoot further or validate against a production analytics database.

---

## Author

Eklovey Khanna
