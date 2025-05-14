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
DROP TABLE IF EXISTS freight;
DROP TABLE IF EXISTS vehicle_assignment;
DROP TABLE IF EXISTS supplier;
DROP TABLE IF EXISTS staff;
DROP TABLE IF EXISTS staff_role;
DROP TABLE IF EXISTS license_plate;
DROP TABLE IF EXISTS vehicle;
DROP TABLE IF EXISTS vehicle_model;
DROP TABLE IF EXISTS vehicle_type;
DROP TABLE IF EXISTS manufacturer_base;
DROP TABLE IF EXISTS manufacturer;
DROP TABLE IF EXISTS garage_fuel_prices;
DROP TABLE IF EXISTS garage;
DROP TABLE IF EXISTS contact_info;
DROP TABLE IF EXISTS address;
DROP TABLE IF EXISTS address_type;
DROP TABLE IF EXISTS fuel;
DROP TABLE IF EXISTS country;

--CREATE TABLES
CREATE TABLE IF NOT EXISTS country(
	country_id INT SERIAL PRIMARY KEY,
	country_name VARCHAR(30) NOT  NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS fuel(
	fuel_id INT SERIAL PRIMARY KEY,
	fuel_type VARCHAR(12),
	fuel_description TEXT
);

CREATE TABLE IF NOT EXISTS address_type(
	addr_type_id INT SERIAL PRIMARY KEY,
	addr_type_name VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS address(
	address_id INT SERIAL PRIMARY KEY,
	street VARCHAR(100),
	town VARCHAR(100),
	postcode VARCHAR(7),
	address_type_id INT,
	FOREIGN KEY (address_type_id) REFERENCES address_type(addr_type_id)
	ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS contact_info(
	contact_id INT SERIAL PRIMARY KEY,
	email_address VARCHAR(80),
	phone_number VARCHAR(15)
);

CREATE TABLE IF NOT EXISTS garage(
	garage_id INT SERIAL PRIMARY KEY,
	garage_name VARCHAR(40),
	contact_id INT,
	address_id INT,
	FOREIGN KEY (contact_id) REFERENCES contact_info(contact_id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	FOREIGN KEY (address_id) REFERENCES address(address_id)
	ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS garage_fuel_prices(
	price_id INT SERIAL PRIMARY KEY,
	garage_id INT,
	price DECIMAL(10,2),
	price_date DATE,
	FOREIGN KEY (garage_id) REFERENCES garage(garage_id)
	ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS manufacturer(
	manufacturer_id INT SERIAL PRIMARY KEY,
	manufacturer_name VARCHAR(40),
	contact_id INT,
	country_of_origin INT,
	FOREIGN KEY (contact_id) REFERENCES contact_info(contact_id)
	ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (country_of_origin) REFERENCES country(country_id)
	ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS manufacturer_base(
	base_id INT SERIAL PRIMARY KEY,
	manufacturer_id INT,
	base_name VARCHAR(50),
	address_id INT,
	service_type VARCHAR(40),
	FOREIGN KEY manufacturer_id REFERENCES manufacturer(manufacturer_id)
	ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (address_id) REFERENCES address(address_id)
	ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS vehicle_type(
	vehicle_type_id INT SERIAL PRIMARY KEY,
	vehicle_type_name VARCHAR(45),
	fuel_id INT,
	fuel_capacity INT,
	FOREIGN KEY (fuel_id) REFERENCES fuel(fuel_id)
	ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS vehicle_model(
	model_id INT SERIAL PRIMARY KEY,
	model_name VARCHAR(45),
	manufacturer_id INT,
	vehicle_type_id INT,
	FOREIGN KEY (manufacturer_id) REFERENCES manufacturer(manufacturer_id) 
	ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (vehicle_type_id) REFERENCES vehicle_type(vehicle_type_id)
	ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS vehicle(
	vehicle_id INT SERIAL PRIMARY KEY,
	vehicle_number VARCHAR(100),
	model_id INT,
	manufacturer_year YEAR,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	mileage INT DEFAULT 0,
	FOREIGN KEY (model_id) REFERENCES vehicle_model(model_id)
	ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS license_plate(
	license_plate_id INT SERIAL PRIMARY KEY,
	vehicle_id INT,
	license_plate VARCHAR(20),
	start_date DATE,
	end_date DATE,
	FOREIGN KEY (vehicle_id) REFERENCES vehicle(vehicle_id)
	ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS staff_role(
	role_id INT SERIAL PRIMARY KEY,
	role_name VARCHAR(45)
);

CREATE TABLE IF NOT EXISTS staff(
	staff_id INT SERIAL PRIMARY KEY,
	surname VARCHAR(50),
	forename VARCHAR(50),
	role_id INT,	
	hire_date DATE,
	contact_id INT,
	address_id INT,
	FOREIGN KEY (role_id) REFERENCES staff_role(role_id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	FOREIGN KEY (contact_id) REFERENCES contact_info(contact_id)
	ON DELETE CASCADE
	ON UPDATE CASCADE,
	FOREIGN KEY (address_id) REFERENCES address(address_id)
	ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS supplier(
	supplier_id INT SERIAL PRIMARY KEY,
	supplier_name VARCHAR(50),
	contact_name VARCHAR(50),
	contact_id INT,
	address_id INT, 
	FOREIGN KEY (contact_id) REFERENCES contact_info(contact_id)
	ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (address_id) REFERENCES address(address_id)
	ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS contract_status(
	status_id INT SERIAL PRIMARY KEY,
	contract_status VARCHAR (20)
);

CREATE TABLE IF NOT EXISTS supplier_contract(
	contract_id INT SERIAL PRIMARY KEY,
	supplier_id INT,
	contract_start_date DATE,
	contract_end_date DATE,
	contract_terms TEXT,
	status_id INT,
	contract_value DECIMAL(12, 2),
	contract_renewal_date DATE,
	FOREIGN KEY (status_id) REFERENCES contract_status(status_id) ON DELETE CASCADE,
	FOREIGN KEY (supplier_id) REFERENCES supplier(supplier_id)
	ON DELETE CASCADE ON UPDATE CASCADE

);

CREATE TABLE IF NOT EXISTS vehicle_assignment(
	assignment_id INT SERIAL PRIMARY KEY,
	vehicle_id INT,
	staff_id INT,
	start_date DATE,
	end_date DATE,
	FOREIGN KEY (vehicle_id) REFERENCES vehicle(vehicle_id)
	ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
	ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS freight(
	freight_id INT SERIAL PRIMARY KEY,
	freight_name VARCHAR(45),
	freight_description TEXT
);

CREATE TABLE IF NOT EXISTS shipment(
	shipment_id INT SERIAL PRIMARY KEY,
	freight_id INT,
	origin_address_id INT,
	dest_address_id INT,
	shipment_date DATE,
	delivery_date DATE,
	FOREIGN KEY (freight_id) REFERENCES freight(freight_id)
	ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (origin_address_id) REFERENCES address(address_id)
	ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (dest_address_id) REFERENCES address(address_id)
	ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS vehicle_shipment(
	delivery_id INT SERIAL PRIMARY KEY,
	assignment_id INT,
	shipment_id INT,
	FOREIGN KEY (assignment_id) REFERENCES vehicle_assignment(assignment_id)
	ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (shipment_id) REFERENCES shipment(shipment_id)
	ON DELETE CASCADE ON UPDATE CASCADE
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

--POPULATE TABLES
INSERT INTO country (country_name) VALUES 
	('United Kingdom'),
	('Sweden'),
	('Netherlands');

INSERT INTO fuel (fuel_type, fuel_description) VALUES
	('Diesel', 'Commercial Diesel Fuel'),
	('Petrol', 'Commercial Petrol Fuel'),
	('Electric', 'Electric powered vehicles'),
	('Hybrid', 'Hybrid Fuel system');

INSERT INTO address_type (addr_type_name) VALUES
	('Staff'),
	('Manufacturer HQ'),
	('Garage'),
	('Dealership');

INSERT INTO address (street, town, postcode, address_type_id) VALUES
	('Mylord Crescent', 'Newcastle Upon Tyne', 'NE12 5UW', 4); --Scania

INSERT INTO contact_info (email_address, phone_number) VALUES
	('contact@ukgarage.com', '+441253151561');


INSERT INTO vehicle_model (model_name, manufacturer_id, vehicle_type_id) VALUES
('Scania R500', 1, 1)



--JOINS: INNER JOIN, LEFT JOIN, RIGHT JOIN


--Queries
--SELECT a.*, at.addr_type_name
--FROM address a
--JOIN address_type at ON a.address_type_id = at.addr_type_id
--WHERE at.addr_type_name = 'Garage';

