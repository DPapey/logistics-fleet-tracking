--CREATE DATABASE eurofleet_logistics;

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
DROP TABLE IF EXISTS supplier_contract;
DROP TABLE IF EXISTS vehicle_assignment;
DROP TABLE IF EXISTS contract_status;
DROP TABLE IF EXISTS supplier;
DROP TABLE IF EXISTS staff_certification;
DROP TABLE IF EXISTS certification_type;
DROP TABLE IF EXISTS staff;
DROP TABLE IF EXISTS staff_role;
DROP TABLE IF EXISTS clearance_level;
DROP TABLE IF EXISTS license_plate;
DROP TABLE IF EXISTS vehicle;
DROP TABLE IF EXISTS vehicle_model;
DROP TABLE IF EXISTS vehicle_type;
DROP TABLE IF EXISTS dealership;
DROP TABLE IF EXISTS garage;
DROP TABLE IF EXISTS contact_info;
DROP TABLE IF EXISTS address;
DROP TABLE IF EXISTS address_type;
DROP TABLE IF EXISTS powertrain;

--CREATE TABLES

-- Crucial for type of vehicle power.
CREATE TABLE powertrain(
	powertrain_id SERIAL PRIMARY KEY,
	powertrain_type VARCHAR(20),
	powertrain_description TEXT
);

-- Important for querying, such as in address WHERE address_type = n
CREATE TABLE address_type(
	addr_type_id SERIAL PRIMARY KEY,
	addr_type_name VARCHAR(50)
);

-- Address information for various tables (garage, dealership, shipment origin/destination etc)
CREATE TABLE address(
	address_id SERIAL PRIMARY KEY,
	street VARCHAR(100) NOT NULL,
	town VARCHAR(100),
	postcode VARCHAR(7) NOT NULL,
	address_type_id INT NOT NULL,
	FOREIGN KEY (address_type_id) REFERENCES address_type(addr_type_id)
	ON DELETE CASCADE ON UPDATE CASCADE
);

-- Relevant Contact Information
CREATE TABLE contact_info(
	contact_id SERIAL PRIMARY KEY,
	email_address VARCHAR(80) NOT NULL,
	phone_number VARCHAR(13)
);

-- Handling of storing trucks, maintenance
CREATE TABLE garage(
	garage_id SERIAL PRIMARY KEY,
	garage_name VARCHAR(50),
	contact_id INT,
	address_id INT,
	FOREIGN KEY (contact_id) REFERENCES contact_info(contact_id)
	ON DELETE CASCADE,
	FOREIGN KEY (address_id) REFERENCES address(address_id)
	ON DELETE CASCADE ON UPDATE CASCADE
);

-- Dealerships for the Trucks (Location, contact info)
CREATE TABLE dealership(
	dealership_id SERIAL PRIMARY KEY,
	dealership_name VARCHAR(50) NOT NULL,
	address_id INT NOT NULL,
	contact_id INT NOT NULL,
	FOREIGN KEY (address_id) REFERENCES address(address_id)
	ON DELETE CASCADE,
	FOREIGN KEY (contact_id) REFERENCES contact_info(contact_id)
	ON DELETE CASCADE
);

-- The types of vehicle (Scania have many)
CREATE TABLE vehicle_type(
	vehicle_type_id SERIAL PRIMARY KEY,
	vehicle_type_name VARCHAR(40)
);


CREATE TABLE vehicle_model(
	model_id SERIAL PRIMARY KEY,
	model_name VARCHAR(40),
	powertrain_id INT,
	vehicle_type_id INT,
	FOREIGN KEY (powertrain_id) REFERENCES powertrain(powertrain_id),
	FOREIGN KEY (vehicle_type_id) REFERENCES vehicle_type(vehicle_type_id)
);

-- Vehicle itself implementing prior table info, plus as its fleet vehicles, includes when purchased, mileage trackable for legality, 
CREATE TABLE vehicle(
	vehicle_id SERIAL PRIMARY KEY,
	vehicle_number VARCHAR(100),
	model_id INT,
	manufactured_year SMALLINT CHECK (manufactured_year BETWEEN 1900 AND EXTRACT(YEAR FROM CURRENT_DATE)),
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	mileage INT DEFAULT 0,
	FOREIGN KEY (model_id) REFERENCES vehicle_model(model_id)
	ON DELETE CASCADE 
);

CREATE TABLE license_plate(
	license_plate_id SERIAL PRIMARY KEY,
	vehicle_id INT NOT NULL,
	license_plate VARCHAR(20) NOT NULL,
	start_date DATE NOT NULL,
	end_date DATE,
	FOREIGN KEY (vehicle_id) REFERENCES vehicle(vehicle_id)
	ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE clearance_level(
	clearance_id SERIAL PRIMARY KEY,
	clearance_type VARCHAR(40) NOT NULL UNIQUE,
	clearance_description TEXT
);

CREATE TABLE staff_role(
	staff_role_id SERIAL PRIMARY KEY,
	role_name VARCHAR(40),
	clearance_id INT NOT NULL,
	FOREIGN KEY (clearance_id) REFERENCES clearance_level(clearance_id) 
);
-- DOnt wish to cascade delete clearance levels.

CREATE TABLE staff(
	staff_id SERIAL PRIMARY KEY,
	surname VARCHAR(30),
	forename VARCHAR(30),
	staff_role_id INT NOT NULL,	
	hire_date DATE NOT NULL,
	contact_id INT NOT NULL,
	address_id INT NOT NULL,
	FOREIGN KEY (staff_role_id) REFERENCES staff_role(staff_role_id)
	ON DELETE CASCADE,
	FOREIGN KEY (contact_id) REFERENCES contact_info(contact_id)
	ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (address_id) REFERENCES address(address_id)
	ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE certification_type(
	cert_type_id SERIAL PRIMARY KEY,
	cert_name VARCHAR(30) NOT NULL
);


CREATE TABLE staff_certification(
	staff_cert_id SERIAL PRIMARY KEY,
	staff_id INT NOT NULL,
	cert_type_id INT NOT NULL,
	expiry_date DATE NOT NULL,
	FOREIGN KEY (staff_id) REFERENCES staff(staff_id),
	FOREIGN KEY (cert_type_id) REFERENCES certification_type(cert_type_id),
	UNIQUE (staff_id, cert_type_id)
);

CREATE TABLE supplier(
	supplier_id SERIAL PRIMARY KEY,
	supplier_name VARCHAR(50) NOT NULL,
	contact_surname VARCHAR(30),
	contact_forename VARCHAR(30),
	contact_id INT NOT NULL,
	address_id INT NOT NULL, 
	FOREIGN KEY (contact_id) REFERENCES contact_info(contact_id)
	ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (address_id) REFERENCES address(address_id)
	ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE contract_status( 
	contract_status_id SERIAL PRIMARY KEY,
	contract_status VARCHAR (15)
);

CREATE TABLE supplier_contract(
	contract_id SERIAL PRIMARY KEY,
	supplier_id INT NOT NULL,
	contract_start_date DATE NOT NULL,
	contract_end_date DATE NOT NULL,
	contract_terms TEXT NOT NULL,
	contract_status_id INT NOT NULL,
	contract_value DECIMAL(12, 2) NOT NULL,
	contract_renewal_date DATE,
	FOREIGN KEY (contract_status_id) REFERENCES contract_status(contract_status_id),
	FOREIGN KEY (supplier_id) REFERENCES supplier(supplier_id)
);

-- Assigning Staff to Vehicles
CREATE TABLE vehicle_assignment(
	assignment_id SERIAL PRIMARY KEY, 
	vehicle_id INT NOT NULL,
	staff_id INT NOT NULL,
	start_date DATE NOT NULL,
	end_date DATE,
	FOREIGN KEY (vehicle_id) REFERENCES vehicle(vehicle_id)
	ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (staff_id) REFERENCES staff(staff_id)
	ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE freight(
	freight_id SERIAL PRIMARY KEY,
	freight_name VARCHAR(45),
	freight_description TEXT
);

CREATE TABLE shipment_status(
	shipment_status_id SERIAL PRIMARY KEY,
	shipment_status_name VARCHAR(50) NOT NULL,
	shipment_status_description TEXT
);

CREATE TABLE shipment(
	shipment_id SERIAL PRIMARY KEY,
	freight_id INT NOT NULL,
	origin_address_id INT NOT NULL,
	dest_address_id INT NOT NULL,
	shipment_date DATE NOT NULL,
	delivery_date DATE NOT NULL,
	FOREIGN KEY (freight_id) REFERENCES freight(freight_id),	
	FOREIGN KEY (origin_address_id) REFERENCES address(address_id),
	FOREIGN KEY (dest_address_id) REFERENCES address(address_id)
	
);

--Assigns a shipment to a vehicle
CREATE TABLE vehicle_shipment(
	delivery_id SERIAL PRIMARY KEY,
	assignment_id INT NOT NULL,
	shipment_id INT NOT NULL,
	FOREIGN KEY (assignment_id) REFERENCES vehicle_assignment(assignment_id),
	FOREIGN KEY (shipment_id) REFERENCES shipment(shipment_id)
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


--Timestamp Update Trigger Function
CREATE OR REPLACE FUNCTION update_modified_column()
RETURNS TRIGGER AS $$
BEGIN
	NEW.updated_at = NOW();
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER set_timestamp
BEFORE UPDATE ON vehicle
FOR EACH ROW
	EXECUTE FUNCTION update_modified_column();
