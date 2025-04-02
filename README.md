# Logistics Fleet Management Database Schema

## Project Overview
The **Logistics Fleet Management** project is designed to manage and track a logistics fleet, including driver and vehicle assignments, and shipment tracking. This schema ensures data integrity, efficient processing, and scalability for handling real-time logistics operations.

## Technologies Used
- **MariaDB**: Relational database management system for data storage.
- **SQL**: Utilized for database queries, data retrieval, and indexing.
- **3NF (Third Normal Form)**: The schema design follows 3NF to reduce data redundancy and improve data integrity.


## Features
- **3NF-Compliant Database**: The database schema follows the principles of the third normal form, ensuring efficient storage and minimized data redundancy.
- **ACID Transactions**: The database design supports ACID properties to ensure reliable transactions.
- **Referential Integrity**: Foreign keys are used to maintain relationships between tables, ensuring data consistency across all related entities (e.g., shipments, vehicles, and staff).
- **Comprehensive SQL Script**: A single, efficient PL/SQL script is used to handle data operations, ensuring fast processing and consistency.

## Purpose
This project aims to:
- Streamline the tracking of shipments and assignments within a logistics company.
- Enable the management of fleet resources, such as drivers, vehicles, and shipment statuses.
- Provide real-time tracking of vehicles and staff, reducing operational delays and improving efficiency.

## Schema Design
The schema includes tables for:
- **Vehicles**: Store information about the fleet's vehicles.
- **Drivers**: Track driver information and their assignments.
- **Shipments**: Manage shipment details and status.
- **Assignments**: Link vehicles and drivers to specific shipments.
  
The relationships between these entities are established using **foreign keys** to ensure data integrity and consistency.
