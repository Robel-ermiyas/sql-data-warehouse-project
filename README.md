# 🧠 Data Warehouse and Analytics Project (PostgreSQL Edition)

Welcome to the **Data Warehouse and Analytics Project** repository! 🚀  
This project demonstrates a full-stack modern data warehouse solution using **PostgreSQL**, built on the Medallion architecture (Bronze, Silver, Gold layers). Designed for portfolio and real-world readiness, it features best practices in **Data Engineering**, **ETL**, **Data Modeling**, and **Analytics**.

---

## 🏗️ Data Architecture: Medallion Layers

This project is structured using the **Medallion Architecture**:

![Data Architecture](docs/Data_Architecture.png)

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
- 🐘 **PostgreSQL** – Relational DBMS used across all layers
- 🧠 **pgAdmin / DBeaver** – GUI tools to interact with PostgreSQL
- 📝 **DrawIO** – Data architecture and flow diagrams
- 🧱 **SQL** – Entire ETL, DDL, and transformations written in PostgreSQL SQL
- 🧾 **Notion Template** – [Project Steps](https://thankful-pangolin-2ca.notion.site/SQL-Data-Warehouse-Project-16ed041640ef80489667cfe2f380b269?pvs=4)

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

