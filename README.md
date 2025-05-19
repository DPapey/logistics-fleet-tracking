# Logistics Fleet Management Database Schema

## Project Overview
**Personal Conceptual Scenario**

Eurofleet Logistics requires a robust and functional database schema to manage their truck fleet and associated dealerships. The system must also maintain detailed contact information for staff members and track which vehicle assignments to individual staff.

Due to operational requirements, staff members need to be categorised based on their training and certifications to ensure safety compliance. This includes Heavy Goods Vehicle (HGV) licenses and handling different hazard types (Hazard Types 1 to 4), as defined by the UK Health and Safety Executive.

While Eurofleet Logistics is headquartered in the UK, their fleet operates across both the UK and the European Union, so the database must support tracking of vehicles and operations in both regions.

To support core logistical activities, the system must also track deliveries, including their origin and destination locations, assigned vehicles and driver, delivery deadlines, and current status (in-transit, delivered, overdue). This allows Eurofleet to monitor delivery performance, manage routing efficiently, and ensure on-time fulfillment.

## Technologies Used
- **MariaDB**: Relational database management system for data storage.
- **SQL**: Utilised for querying, data manipulation, and indexing.
- **3NF (Third Normal Form)**: The schema design adheres to 3NF principles to reduce redundancy and ensure data integrity.
- **Docker**: Used to host MariaDB and phpMyAdmin in local containers, making the DBMS independent from the host environment. This improves security, provides scalability, enables web-browser interfacing, and allows seamless deployment to a VPS.
- **Git**: Used for version control of SQL scripts and documentation.

## Features
- **3NF-Compliant Database**: Ensures efficient data storage and minimises redundancy.
- **ACID Transactions**: Supports Atomicity, Consistency, Isolation and Durability for reliable transactional processing.
- **Referential Integrity**: Foreign keys maintain relationships between tables, ensuring data consistency across entities such as shipments, vehicles and staff.
- **Modular SQL Scripts**: Separate scripts are used for table creation, data population, and querying/testing, improving maintainability, readability and ease of testing.

