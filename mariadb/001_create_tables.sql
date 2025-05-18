CREATE DATABASE IF NOT EXISTS eurofleet_logistics;
use eurofleet_logistics;

--DROP INDEXES
DROP INDEX IF EXISTS idx_address_type_id; 
DROP INDEX IF EXISTS idx_vehicle_id; 
DROP INDEX IF EXISTS idx_staff_id;
DROP INDEX IF EXISTS idx_freight_id; 
DROP INDEX IF EXISTS idx_origin_address_id;
DROP INDEX IF EXISTS idx_dest_address_id;

--DROP TABLES reverse order
DROP TABLE IF EXISTS vehicle_shipment;
DROP TABLE IF EXISTS shipment;
DROP TABLE IF EXISTS shipment_status;
DROP TABLE IF EXISTS freight;
DROP TABLE IF EXISTS vehicle_assignment;
DROP TABLE IF EXISTS contract_status;
DROP TABLE IF EXISTS supplier;
DROP TABLE IF EXISTS staff_certification;
DROP TABLE IF EXISTS certification_type;
DROP TABLE IF EXISTS staff;
DROP TABLE IF EXISTS role_clearance;
DROP TABLE IF EXISTS role;
DROP TABLE IF EXISTS clearance_level;
DROP TABLE IF EXISTS license_plate;
DROP TABLE IF EXISTS vehicle;
DROP TABLE IF EXISTS vehicle_model;
DROP TABLE IF EXISTS vehicle_type;
DROP TABLE IF EXISTS dealership;
DROP TABLE IF EXISTS garage_fuel_prices;
DROP TABLE IF EXISTS garage;
DROP TABLE IF EXISTS contact_info;
DROP TABLE IF EXISTS address;
DROP TABLE IF EXISTS address_type;
DROP TABLE IF EXISTS powertrain_type;

--CREATE TABLES
CREATE TABLE IF NOT EXISTS powertrain_type(
	powertrain_id INT AUTO_INCREMENT PRIMARY KEY,
	powertrain_type VARCHAR(12) NOT NULL UNIQUE,
	powertrain_description TEXT
);

CREATE TABLE IF NOT EXISTS address_type(
	addr_type_id INT AUTO_INCREMENT PRIMARY KEY,
	addr_type_name VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS address(
	address_id INT AUTO_INCREMENT PRIMARY KEY,
	street VARCHAR(100),
	town VARCHAR(100),
	postcode VARCHAR(7) NOT NULL,
	address_type_id INT NOT NULL,
	FOREIGN KEY (address_type_id) REFERENCES address_type(addr_type_id)
	ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS contact_info(
	contact_id INT AUTO_INCREMENT PRIMARY KEY,
	email_address VARCHAR(80) NOT NULL,
	phone_number VARCHAR(15)
);

-- Garages handle storing trucks, maintenance.
CREATE TABLE IF NOT EXISTS garage(
	garage_id INT AUTO_INCREMENT PRIMARY KEY,
	garage_name VARCHAR(40),
	contact_id INT,
	address_id INT,
	FOREIGN KEY (contact_id) REFERENCES contact_info(contact_id)
	ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (address_id) REFERENCES address(address_id)
	ON DELETE CASCADE ON UPDATE CASCADE
);

-- Dealership handles purchasing of vehicles, potentially contacting in issues, warranty etc.
CREATE TABLE IF NOT EXISTS dealership(
	dealership_id INT AUTO_INCREMENT PRIMARY KEY,
	dealership_name VARCHAR(50) NOT NULL,
	address_id INT NOT NULL,
	contact_id INT NOT NULL,
	FOREIGN KEY (address_id) REFERENCES address(address_id)
	ON DELETE CASCADE,
	FOREIGN KEY (contact_id) REFERENCES contact_info(contact_id) 
	ON DELETE CASCADE
);

-- The Vehicle: Data integrity (types being Truck, specific such as Scania different types). 
CREATE TABLE IF NOT EXISTS vehicle_type(
	vehicle_type_id INT AUTO_INCREMENT PRIMARY KEY,
	vehicle_type_name VARCHAR(45) NOT NULL
);

-- Model works with the vehicle itself, its statistics (powertrain, fuel/energy capacity)
CREATE TABLE IF NOT EXISTS vehicle_model(
	model_id INT AUTO_INCREMENT PRIMARY KEY,
	model_name VARCHAR(45),
	vehicle_type_id INT NOT NULL,
	powertrain_id INT NOT NULL,
	fuel_capacity INT NOT NULL,
	FOREIGN KEY (vehicle_type_id) REFERENCES vehicle_type(vehicle_type_id)
	ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (powertrain_id) REFERENCES powertrain_type(powertrain_id)
	ON DELETE CASCADE RESTRICT
);

-- Final integrity for vehicle, the actual vehicle purchased (from the dealership, the vehicle_num, date_of_purchase, mileage on each vehicle)
CREATE TABLE IF NOT EXISTS vehicle(
	vehicle_id INT AUTO_INCREMENT PRIMARY KEY,
	vehicle_number VARCHAR(100),
	model_id INT NOT NULL,
	dealership_id INT NOT NULL,
	manufacturer_year YEAR,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	mileage INT DEFAULT 0,
	FOREIGN KEY (model_id) REFERENCES vehicle_model(model_id),
	FOREIGN KEY (dealership_id) REFERENCES dealership(dealership_id)
	ON DELETE CASCADE
);

-- If plates get stolen, ensure suitable for waiting until vehicle receives another.
-- If an incident occurs, can search the plate and see which vehicle was affected.
CREATE TABLE IF NOT EXISTS license_plate(
	license_plate_id INT AUTO_INCREMENT PRIMARY KEY,
	vehicle_id INT,
	license_plate VARCHAR(20),
	start_date DATE,
	end_date DATE,
	FOREIGN KEY (vehicle_id) REFERENCES vehicle(vehicle_id)
	ON DELETE CASCADE ON UPDATE CASCADE
);

-- Clearance allowance for staff, such as HGV, Hazardous Materials
CREATE TABLE IF NOT EXISTS clearance_level(
	clearance_id INT AUTO_INCREMENT PRIMARY KEY,
	clearance_type VARCHAR(50) NOT NULL UNIQUE,
	clearance_description TEXT
);

-- Roles for staff.
CREATE TABLE role(
	role_id INT AUTO_INCREMENT PRIMARY KEY,
	role_name VARCHAR(45) NOT NULL,
	clearance_id INT NOT NULL,
	FOREIGN KEY (clearance_id) REFERENCES clearance_level(clearance_id)
	ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS staff(
	staff_id INT AUTO_INCREMENT PRIMARY KEY,
	surname VARCHAR(50),
	forename VARCHAR(50),
	role_id INT,	
	hire_date DATE,
	contact_id INT,
	address_id INT,
	FOREIGN KEY (role_id) REFERENCES role(role_id)
	ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (contact_id) REFERENCES contact_info(contact_id)
	ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (address_id) REFERENCES address(address_id)
	ON DELETE CASCADE ON UPDATE CASCADE
);

--Associating staff with trusted certificate, ensuring suitable clearance for HGV, Hazardous Materials etc)
CREATE TABLE IF NOT EXISTS certification_type(
	cert_type_id INT AUTO_INCREMENT PRIMARY KEY,
	cert_name VARCHAR(50) NOT NULL

);

--Staff can have multiple certs, but only 1 of each (can't have duplicates, although if renewed, must forsee data integrity).
CREATE TABLE IF NOT EXISTS staff_certification(
	staff_cert_id INT AUTO_INCREMENT PRIMARY KEY,
	staff_id INT NOT NULL,
	cert_type_id INT NOT NULL,
	start_date DATE NOT NULL,
	expiry_date DATE NOT NULL,
	FOREIGN KEY (staff_id) REFERENCES staff(staff_id),
	FOREIGN KEY (cert_type_id) REFERENCES certification_type(cert_type_id),
	CHECK (expiry_date > start_date),
	UNIQUE (staff_id, cert_type_id, start_date)

);

--Supplier for Goods
CREATE TABLE IF NOT EXISTS supplier(
	supplier_id INT AUTO_INCREMENT PRIMARY KEY,
	supplier_name VARCHAR(50),
	contact_name VARCHAR(50),
	contact_id INT,
	address_id INT, 
	FOREIGN KEY (contact_id) REFERENCES contact_info(contact_id)
	ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (address_id) REFERENCES address(address_id)
	ON DELETE CASCADE ON UPDATE CASCADE
);

--Working with contracts (staff on deliveries)
CREATE TABLE IF NOT EXISTS contract_status(
	contract_status_id INT AUTO_INCREMENT PRIMARY KEY,
	contract_status VARCHAR(15) 
);

CREATE TABLE IF NOT EXISTS supplier_contract(
	contract_id INT AUTO_INCREMENT PRIMARY KEY,
	supplier_id INT NOT NULL,
	contract_start_date DATE NOT NULL,
	contract_end_date DATE NOT NULL,
	contract_terms TEXT NOT NULL,
	contract_status_id INT NOT NULL,
	contract_value DECIMAL(12, 2) NOT NULL,
	contract_renewal_date DATE,
	FOREIGN KEY (supplier_id) REFERENCES supplier(supplier_id)
	ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (contract_status_id) REFERENCES contract_status(contract_status_id)
	ON DELETE RESTRICT
);

--Linking Relation between Vehicle & Staff, assigning staff to a vehicle (1 vehicle, 1 driver).
CREATE TABLE IF NOT EXISTS vehicle_assignment(
	assignment_id INT AUTO_INCREMENT PRIMARY KEY,
	vehicle_id INT NOT NULL,
	staff_id INT NOT NULL,
	start_date DATE NOT NULL,
	end_date DATE NOT NULL,
	FOREIGN KEY (vehicle_id) REFERENCES vehicle(vehicle_id)
	ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
	ON DELETE CASCADE ON UPDATE CASCADE
);

--The logistics carrying.
CREATE TABLE IF NOT EXISTS freight(
	freight_id INT AUTO_INCREMENT PRIMARY KEY,
	freight_name VARCHAR(45) NOT NULL,
	freight_description TEXT
);

--Information on shipments (travelling, retrieving, delivering, delivered).
CREATE TABLE IF NOT EXISTS shipment_status(
	shipment_status_id INT AUTO_INCREMENT PRIMARY KEY,
	shipment_status_name VARCHAR(50) NOT NULL,
	shipment_status_description TEXT
);

--The shipment load carried by truck (origin, destination, the shipment itself)
CREATE TABLE IF NOT EXISTS shipment(
	shipment_id INT AUTO_INCREMENT PRIMARY KEY,
	freight_id INT NOT NULL,
	origin_address_id INT NOT NULL,
	dest_address_id INT NOT NULL,
	shipment_status_id INT NOT NULL,
	shipment_date DATE NOT NULL,
	delivery_date DATE,
	FOREIGN KEY (freight_id) REFERENCES freight(freight_id)
	ON DELETE CASCADE,
	FOREIGN KEY (origin_address_id) REFERENCES address(address_id)
	ON DELETE CASCADE,
	FOREIGN KEY (dest_address_id) REFERENCES address(address_id)
	ON DELETE CASCADE, 
	FOREIGN KEY (shipment_status_id) REFERENCES shipment_status(shipment_status_id) 
	ON DELETE RESTRICT
);

--Linking relation between the vehicle (with driver) and the shipment.
CREATE TABLE IF NOT EXISTS vehicle_shipment(
	delivery_id INT AUTO_INCREMENT PRIMARY KEY,
	assignment_id INT,
	shipment_id INT,
	FOREIGN KEY (assignment_id) REFERENCES vehicle_assignment(assignment_id)
	ON DELETE CASCADE, 
	FOREIGN KEY (shipment_id) REFERENCES shipment(shipment_id)
	ON DELETE CASCADE
);


--CREATE INDEXES
--Address Filtering
CREATE INDEX idx_address_type_id ON address(address_type_id);

--Faster Vehicle assignment
CREATE INDEX idx_vehicle_id ON vehicle_assignment(vehicle_id);
CREATE INDEX idx_staff_id ON vehicle_assignment(staff_id);

--Shipment Query
CREATE INDEX idx_freight_id ON shipment(freight_id);
CREATE INDEX idx_origin_address_id ON shipment(origin_address_id);
CREATE INDEX idx_dest_address_id ON shipment(dest_address_id);




