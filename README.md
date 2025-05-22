# Logistics Fleet Management Database Schema

## Project Overview
**Personal Conceptual Scenario**

This project provides a robust and functional database schema designed to manage Eurofleet Logistics' truck fleet and associated dealerships. The system supports detailed contact information for staff, tracks vehicle assignments, and categorises staff based on training and safety certifications, including HGV licenses and hazard type handling (UK HSE defined Hazard Types 1-4).

Initially developed with MariaDB, the database was subsequently migrated to PostgreSQL to leverage its advanced features and enhanced scalability. The fleet operates across both the UK and the European Union, so the schema supports tracking of vehicles and operations in both regions.

To support core logistical activities, the system also tracks deliveries, including their origin and destination, assigned vehicles and drivers, deadlines, and current status (in-transit, delivered, overdue). This enables efficient monitoring of delivery performance, routing management, and on-time fulfillment.

## Technologies Used
* **PostgreSQL**: The primary relational database management system, chosen for its robust features and scalability.
* **MariaDB**: The initial RDBMS used for development, demonstrating versatility in database environments.
* **SQL**: Utilised extensively for schema definition (DDL), data manipulation (DML), and performance optimisation through indexing.
* **3NF (Third Normal Form)**: The schema design adheres to 3NF principles to minimise redundancy and ensure data integrity.
* **Docker**: Employed to containerise the PostgreSQL database, ensuring environment independence, improved security, scalability, and seamless deployment.
* **Git**: Used for version control of SQL scripts and documentation.

## Features
* **3NF-Compliant Database**: Ensures efficient data storage and minimises redundancy.
* **ACID Transactions**: Supports Atomicity, Consistency, Isolation, and Durability for reliable transactional processing.
* **Referential Integrity**: Robust **Foreign Keys** maintain strong relationships between tables (e.g., shipments, vehicles, staff), ensuring data consistency.
* **Modular SQL Scripts**: Organised scripts for table creation, data population, and querying/testing enhance maintainability, readability, and ease of testing.
* **Database Migration Experience**: Demonstrates practical experience in migrating database systems, highlighting adaptability and problem-solving.

