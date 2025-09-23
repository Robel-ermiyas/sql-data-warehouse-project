# 📦 Data Catalog for Gold Layer (PostgreSQL)

## Overview
The **Gold Layer** in a data warehouse represents the **final business-ready Star Schema**, designed to support advanced analytics and reporting. It consists of **dimension views** and **fact views**, enriched from the Silver Layer with transformations and surrogate keys.

---

### 1. 🧍 gold.dim_customers
- **Purpose:** Stores enriched customer details with demographics and location data.

| Column Name     | PostgreSQL Data Type | Description                                                                                   |
|-----------------|----------------------|-----------------------------------------------------------------------------------------------|
| customer_key    | INT                  | Surrogate key uniquely identifying each customer record.                                      |
| customer_id     | INT                  | Unique identifier assigned to each customer from source systems.                              |
| customer_number | VARCHAR(50)          | Alphanumeric customer reference key (e.g., 'CUS-001').                                        |
| first_name      | VARCHAR(50)          | Customer's first name.                                                                        |
| last_name       | VARCHAR(50)          | Customer's last name or family name.                                                          |
| country         | VARCHAR(50)          | Country of residence (e.g., 'Germany', 'USA').                                                |
| marital_status  | VARCHAR(50)          | Marital status of the customer (e.g., 'Married', 'Single').                                   |
| gender          | VARCHAR(50)          | Gender information (e.g., 'Male', 'Female', or 'n/a' if unknown).                             |
| birthdate       | DATE                 | Date of birth (format: YYYY-MM-DD).                                                           |
| create_date     | DATE                 | Date the customer record was first created.                                                   |

---

### 2. 🛒 gold.dim_products
- **Purpose:** Holds detailed product information enriched with category mappings.

| Column Name          | PostgreSQL Data Type | Description                                                                                   |
|----------------------|----------------------|-----------------------------------------------------------------------------------------------|
| product_key          | INT                  | Surrogate key uniquely identifying each product.                                              |
| product_id           | INT                  | Internal product identifier.                                                                  |
| product_number       | VARCHAR(50)          | Alphanumeric product code (e.g., 'PRD-001').                                                  |
| product_name         | VARCHAR(50)          | Descriptive product name.                                                                     |
| category_id          | VARCHAR(50)          | Category reference code derived from the product key.                                         |
| category             | VARCHAR(50)          | Broad product classification (e.g., 'Components', 'Accessories').                             |
| subcategory          | VARCHAR(50)          | More specific product category (e.g., 'Helmets', 'Brakes').                                   |
| maintenance_required | VARCHAR(50)          | Indicates if the product requires maintenance ('Yes', 'No').                                  |
| cost                 | INT                  | Base cost of the product (in monetary units).                                                 |
| product_line         | VARCHAR(50)          | Product line grouping (e.g., 'Mountain', 'Road').                                             |
| start_date           | DATE                 | Product availability start date.                                                              |

---

### 3. 💰 gold.fact_sales
- **Purpose:** Stores transactional sales records for analysis and reporting.

| Column Name   | PostgreSQL Data Type | Description                                                                                   |
|---------------|----------------------|-----------------------------------------------------------------------------------------------|
| order_number  | VARCHAR(50)          | Unique identifier for each sales order (e.g., 'SO54496').                                     |
| product_key   | INT                  | Foreign key linking to `gold.dim_products`.                                                   |
| customer_key  | INT                  | Foreign key linking to `gold.dim_customers`.                                                  |
| order_date    | DATE                 | Date the order was placed.                                                                    |
| shipping_date | DATE                 | Date the order was shipped.                                                                   |
| due_date      | DATE                 | Payment due date.                                                                             |
| sales_amount  | INT                  | Total sales amount (quantity × price), in whole currency units.                               |
| quantity      | INT                  | Number of units sold.                                                                         |
| price         | INT                  | Unit price of the product.                                                                    |

---
