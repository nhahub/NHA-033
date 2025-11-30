# 📊 AdventureWorks 360: Enterprise Analytics Solution

![Power BI](https://img.shields.io/badge/Power_BI-Desktop-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![MySQL](https://img.shields.io/badge/MySQL-Database-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![SQL](https://img.shields.io/badge/Language-Advanced_SQL-CC2927?style=for-the-badge&logo=microsoft-sql-server&logoColor=white)
![Status](https://img.shields.io/badge/Status-Completed-success?style=for-the-badge)

> **A holistic, End-to-End Business Intelligence solution designed to bridge the gap between Data Engineering and Strategic Decision Making.**

---

## 📖 Executive Summary
This project represents a simulation of a real-world enterprise data environment for **AdventureWorks**, a multinational manufacturing and retail organization. Unlike standard academic projects, our team adopted a **Domain-Driven Architecture**.

We moved away from task-based isolation. Instead, each team member operated as a **Full-Stack BI Analyst** for a specific business vertical (e.g., Supply Chain, Finance, CRM), owning the entire data lifecycle:
1.  **Extraction:** Querying raw data from the Data Warehouse using complex SQL.
2.  **Modeling:** Designing efficient Star Schemas optimized for reporting.
3.  **Analytics:** Developing DAX logic for high-level KPIs.
4.  **Visualization:** Creating user-centric dashboards for stakeholder reporting.

---

## 🏗️ Technical Architecture & Tech Stack

We utilized a modern BI stack to ensure performance and scalability.

| Layer | Technology | Key Activities |
| :--- | :--- | :--- |
| **Data Storage** | `AdventureWorks DW` (MySQL) | Hosting millions of transaction records across Sales, Finance, and Inventory. |
| **Data Engineering** | `Advanced SQL` | Implementing **Views**, **CTEs**, and **Window Functions** for data pre-aggregation and cleaning. |
| **Data Modeling** | `Star Schema` | Designing Fact & Dimension tables with 1-to-Many relationships to ensure query performance. |
| **Semantic Layer** | `DAX` | Creating dynamic measures for **Time Intelligence** (YoY, YTD), **Ranking**, and **Segmentation**. |
| **Visualization** | `Power BI` | designing a unified **Dark Mode Theme** with intuitive navigation and drill-through capabilities. |

---

## 📂 Repository Structure

| Folder | Contents & Description |
| :--- | :--- |
| **📁 01_Documentation** | Contains the comprehensive **Project Proposal**, Entity Relationship Diagrams (ERD), and Methodology documentation. |
| **📁 02_Project_Files** | **The Core Source Code:**<br>• `SQL Scripts`: DDL for Database creation, Views, and ETL pipelines.<br>• `Power BI`: The final `.pbix` file containing the data model and reports. |
| **📁 03_Presentation** | **Final Deliverables:**<br>• Executive PowerPoint slides showcasing business insights, data storytelling, and strategic recommendations. |

---

## 🔍 Analytical Modules & Key Insights

This solution is divided into 5 specialized domains, mirroring our team's functional structure:

### 1️⃣ 📊 Financial & Operational Performance
* **Focus:** Holistic view of the bottom line and workforce efficiency.
* **Key Metrics:** Net Profit Margin, Budget Variance, Service Grade (Good/Normal/Bad), Cost of Operations.
* **Insight:** Correlating financial health with operational bottlenecks (e.g., How does call center efficiency impact operational costs?).

### 2️⃣ 🤝 Sales Performance (B2B)
* **Focus:** Reseller & Distributor Partnerships.
* **Key Metrics:** Wholesale Revenue, Bulk Order Trends, Reseller Performance Ranking by Region.
* **Insight:** Identifying high-value partners and underperforming territories to optimize supply chain distribution.

### 3️⃣ 🛒 Sales Performance (B2C)
* **Focus:** Direct Internet Sales & E-commerce Trends.
* **Key Metrics:** Online Revenue Growth, Order Frequency, Average Order Value (AOV).
* **Insight:** Tracking individual consumer purchasing behaviors to drive e-commerce strategies.

### 4️⃣ 📦 Product & Inventory Analysis
* **Focus:** Supply Chain Optimization & Product Lifecycle.
* **Key Metrics:** Stock Turnover Ratio, Days Sales of Inventory (DSI), Product Profitability.
* **Insight:** Balancing stock levels to minimize holding costs while preventing stockouts of high-demand items.

### 5️⃣ 👥 Customer & Market Insights
* **Focus:** Demographics, Segmentation, and Retention.
* **Key Metrics:** Customer Churn Risk, RFM Analysis (Recency, Frequency, Monetary), Regional Market Penetration.
* **Insight:** Creating detailed customer personas to tailor marketing campaigns and improve retention rates.

---

## 🚀 How to Run the Project (للتشغيل)

To view the full interactive dashboard with data:

1.  **Database:** Import the provided `.sql` file into your **MySQL Workbench** to create the Data Warehouse.
2.  **Power BI:** Open the `.pbix` file. If prompted, go to `File > Options > Data Source Settings` and update the server name to your local MySQL instance.

---

👥 The Team
Submitted as a Graduation Project for DEPI

Mahmoud Moustafa | Teem Leader | Financial & Operational Performance Analyst
Yousef Khaled | Sales Performance Analyst B2B
Yousef Asaad | Sales Performance Analyst B2C
Rehab Ashraf | Product & Inventory Analyst
Shahd Soliman | Customer & Market Insights Analyst
