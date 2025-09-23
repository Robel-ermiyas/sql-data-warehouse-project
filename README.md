# 🧠 Data Warehouse and Analytics Project (PostgreSQL Edition)

Welcome to the **Data Warehouse and Analytics Project** repository! 🚀  
This project demonstrates a full-stack modern data warehouse solution using **PostgreSQL**, built on the Medallion architecture (Bronze, Silver, Gold layers). Designed for portfolio and real-world readiness, it features best practices in **Data Engineering**, **ETL**, **Data Modeling**, and **Analytics**.

---

## 🏗️ Data Architecture: Medallion Layers

This project is structured using the **Medallion Architecture**:

![Data Architecture](docs/data_architecture.png)

1. **Bronze Layer**: Ingests and stores raw data directly from CSV files into PostgreSQL using `COPY` statements.
2. **Silver Layer**: Performs transformations—such as cleansing, standardizing, and joining—to produce cleaned relational tables.
3. **Gold Layer**: Models the final star schema using **PostgreSQL views** for analytics and BI.

---

## 📖 Project Highlights

This project includes:

1. ✅ **Modern Data Architecture**: PostgreSQL with layered Medallion design.
2. ✅ **ETL Process Automation**: Through **stored procedures** (`plpgsql`) for Bronze and Silver loading.
3. ✅ **Data Modeling**: Structured star schema with dimensions and facts in the Gold layer.
4. ✅ **Analytics-Ready**: Business-ready data for reporting and visual insights.

🎯 Ideal for showcasing skills in:
- SQL & PostgreSQL Development  
- Data Engineering & ETL Automation  
- Data Modeling (Star Schema)  
- BI Readiness for Reporting & Dashboards

---

## 🛠️ Tools & Resources

Everything used here is free and open-source:

- 📂 **[Datasets](datasets/)** – CRM & ERP CSV files used in Bronze layer
- 🐘 **[PostgreSQL](https://www.postgresql.org/download/):** Relational DBMS used across all layers
- 🧠 **pgAdmin / DBeaver** – GUI tools to interact with PostgreSQL
- 🧠 **[Git Repository](https://github.com/):** Set up a GitHub account and repository to manage, version, and collaborate on your code efficiently.
- 📝 **[DrawIO](https://www.drawio.com/):** – Data architecture and flow diagrams


---

## 🚀 Project Scope & Deliverables

### 🏗️ Data Warehouse Development (Data Engineering)

**Objective:**  
Build a robust PostgreSQL data warehouse that consolidates customer, sales, and product data.

**Key Tasks:**
- ✅ Ingest CSVs from ERP & CRM (Bronze)
- ✅ Clean & transform into structured relational models (Silver)
- ✅ Model dimensions and facts for analytics (Gold)

**Data Quality Goals:**
- Remove duplicates
- Normalize inconsistent values
- Convert datatypes (dates, codes)
- Ensure referential integrity

---

### 📊 Analytics & Insights (Data Analysis)

**Objective:**  
Enable reporting on customer behavior, product performance, and sales trends.

**Data Model:**
- **Gold Layer** with:
  - `dim_customers`
  - `dim_products`
  - `fact_sales`

**Outputs:**
- SQL queries for insights
- BI-ready dataset (Gold views)

Refer to [docs/data_catalog.md](docs/data_catalog.md) for full metadata.

---

## 📁 Repository Structure

