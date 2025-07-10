CREATE DATABASE MD10thJ2_db;
USE MD10thJ2_db;

CREATE TABLE vehicles(
    vehicle_id        INT PRIMARY KEY AUTO_INCREMENT,
    vin               TEXT,
    make              TEXT,
    model             TEXT,
    year              INT,
    engine_type       TEXT,
    purchase_date     DATE,
    current_mileage   INT,
    license_plate     TEXT
);

SELECT * FROM vehicles ;

INSERT INTO vehicles(vin,make,model,year,engine_type,purchase_date,current_mileage,license_plate) VALUES
	('1HGCM82633A123456', 'Honda', 'Accord', 2020, '2.0L Turbo', '2020-03-15', 38500, 'ABC1234'),
	('5XYZH4AG4JH123456', 'Toyota', 'Camry', 2018, '2.5L Hybrid', '2018-06-22', 67250, 'XYZ5678'),
	('WAUZZZ4G6BN123456', 'Audi', 'A4', 2021, '2.0L TFSI', '2021-01-10', 18750, 'AUDI202'),
	('1C4RJFBG5EC123456', 'Jeep', 'Wrangler', 2022, '3.6L V6', '2022-05-05', 12500, 'JEEP4X4');

CREATE TABLE owners(
    owner_id   INT PRIMARY KEY AUTO_INCREMENT,
    first_name TEXT,
    last_name  TEXT,
    email      TEXT,
    phone      TEXT,
    address    TEXT
);

SELECT * FROM owners ;

INSERT INTO owners(first_name,last_name,email,phone,address) VALUES
	('John', 'Smith', 'john.smith@email.com', '555-123-4567', '123 Main St, Anytown'),
	('Sarah', 'Johnson', 'sarah.j@email.com', '555-234-5678', '456 Oak Ave, Somewhere'),
	('Michael', 'Williams', NULL, '555-345-6789', '789 Pine Rd, Nowhere');
	
CREATE TABLE ownership(
    ownership_id   INT PRIMARY KEY AUTO_INCREMENT,
    vehicle_id     INT,
    owner_id       INT,
    purchase_date  DATE,
    sale_date      DATE,
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id),
    FOREIGN KEY (owner_id) REFERENCES owners(owner_id)
);

SELECT * FROM ownership ;

INSERT INTO ownership(vehicle_id,owner_id,purchase_date,sale_date) VALUES
	(1, 1, '2020-03-15', NULL),
	(2, 2, '2018-06-22', NULL),
	(3, 3, '2021-01-10', NULL),
	(4, 1, '2022-05-05', NULL);

CREATE TABLE service_types(
    service_id                   INT PRIMARY KEY AUTO_INCREMENT,
    service_name                 TEXT,
    description                  TEXT,
    recommended_interval_miles   INT,
    recommended_interval_months  INT
);

SELECT * FROM service_types ;

INSERT INTO service_types(service_name,description,recommended_interval_miles,recommended_interval_months) VALUES
	('Oil Change', 'Engine oil and filter replacement', 5000, 6),
	('Tire Rotation', 'Rotating tires for even wear', 7500, 6),
	('Brake Inspection', 'Complete brake system check', 15000, 12),
	('Transmission Service', 'Fluid flush and filter replacement', 60000, 48),
	('Coolant Flush', 'Cooling system service', 30000, 24),
	('Air Filter Replacement', 'Engine air filter replacement', 15000, 12),
	('Battery Replacement', '12V battery replacement', NULL, 60);

CREATE TABLE maintenance_records(
    record_id      INT PRIMARY KEY AUTO_INCREMENT,
    vehicle_id     INT,
    service_date   DATE,
    mileage        INT,
    service_id     INT,
    cost           DECIMAL(10,2),
    service_notes  TEXT,
    service_center TEXT,
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id),
    FOREIGN KEY (service_id) REFERENCES service_types(service_id)
);

SELECT * FROM maintenance_records ;

INSERT INTO maintenance_records(vehicle_id,service_date,mileage,service_id,cost,service_notes,service_center) VALUES
	(1, '2023-01-10', 32000, 1, 59.99, 'Used synthetic oil', 'QuickLube Pro'),
	(1, '2023-01-10', 32000, 2, 29.99, 'Standard rotation pattern', 'QuickLube Pro'),
	(1, '2023-07-15', 37000, 1, 64.99, 'Synthetic oil with filter', 'Dealer Service'),
	(2, '2023-03-22', 63000, 1, 49.99, 'Conventional oil', 'Oil Change Express'),
	(2, '2023-03-22', 63000, 3, 0.00, 'Brakes at 50%', 'Oil Change Express'),
	(3, '2023-05-05', 15000, 1, 89.99, 'Full synthetic Euro blend', 'Audi Specialist');

CREATE TABLE parts(
    part_id                 INT PRIMARY KEY AUTO_INCREMENT,
    part_name               TEXT,
    part_number             TEXT,
    compatible_models       TEXT,
    average_lifespan_miles  INT
);

SELECT * FROM parts ;

INSERT INTO parts(part_name,part_number,compatible_models,average_lifespan_miles) VALUES
	('Synthetic Oil 5W-30', 'OIL-5W30-SYN', 'Most gasoline engines', 5000),
	('Oil Filter', 'OF-H001', 'Honda 2015-2023', 5000),
	('Cabin Air Filter', 'CAF-UNIV', 'Universal fit', 15000),
	('Engine Air Filter', 'EAF-H002', 'Honda 2018-2023', 15000),
	('Brake Pads Set', 'BP-TOY01', 'Toyota Camry 2015-2020', 40000),
	('12V Battery', 'BAT-65D', 'Most sedans', 50000);

CREATE TABLE parts_used(
    usage_id    INT PRIMARY KEY AUTO_INCREMENT,
    record_id   INT,
    part_id     INT,
    quantity    INT,
    unit_price  DECIMAL(10,2),
    FOREIGN KEY (record_id) REFERENCES maintenance_records(record_id),
    FOREIGN KEY (part_id) REFERENCES parts(part_id)
);

SELECT * FROM parts_used ;

INSERT INTO parts_used(record_id,part_id,quantity,unit_price) VALUES
	(1, 1, 1, 29.99),
	(1, 2, 1, 19.99),
	(2, NULL, NULL, NULL),
	(3, 1, 1, 34.99),
	(3, 2, 1, 19.99),
	(4, 1, 1, 24.99),
	(4, NULL, NULL, NULL),
	(5, NULL, NULL, NULL),
	(6, 1, 1, 49.99),
	(6, NULL, 1, 29.99);

CREATE TABLE fuel_logs(
    log_id          INT PRIMARY KEY AUTO_INCREMENT,
    vehicle_id      INT,
    fuel_date       DATE,
    mileage         INT,
    fuel_amount     DECIMAL(10,2),
    fuel_cost       DECIMAL(10,2),
    fuel_type       TEXT,
    mpg_calculated  DECIMAL(10,2),
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id)
);

SELECT * FROM fuel_logs ;

INSERT INTO fuel_logs(vehicle_id,fuel_date,mileage,fuel_amount,fuel_cost,fuel_type,mpg_calculated) VALUES
	(1, '2023-10-01', 38000, 12.5, 45.00, 'Regular', 28.4),
	(1, '2023-10-08', 38350, 14.2, 51.12, 'Regular', 24.6),
	(2, '2023-10-03', 67000, 10.8, 38.88, 'Regular', 32.1),
	(3, '2023-10-05', 18500, 13.5, 60.75, 'Premium', 27.8),
	(4, '2023-10-10', 12300, 18.2, 72.80, 'Regular', 19.2);

SELECT 
	*
FROM vehicles
ORDER BY YEAR;

SELECT 
	make,AVG(current_mileage) AS Current_mileage
FROM vehicles
GROUP BY make;

SELECT 
	DISTINCT v.*
FROM vehicles v 
JOIN maintenance_records mr ON v.vehicle_id=mr.vehicle_id
WHERE LOWER(mr.service_notes) LIKE '%synthetic oil%';

SELECT 
    v.vin,v.make,v.model,v.year,
    mr.service_date,mr.mileage,st.service_name,
    mr.cost,mr.service_notes,mr.service_center
FROM vehicles v
JOIN maintenance_records mr ON v.vehicle_id = mr.vehicle_id
LEFT JOIN service_types st ON mr.service_id = st.service_id
WHERE v.vin = '1HGCM82633A123456'
ORDER BY mr.service_date;
    
SELECT 
    v.vin,v.make,v.model,v.year,
    SUM(mr.cost) AS total_maintenance_cost
FROM maintenance_records mr
JOIN vehicles v ON mr.vehicle_id = v.vehicle_id
GROUP BY v.vin, v.make, v.model, v.year
ORDER BY total_maintenance_cost DESC;
    
SELECT 
    v.vin,v.make,v.model,v.year,v.current_mileage,
    MAX(mr.mileage) AS last_oil_change_mileage,
    (v.current_mileage - MAX(mr.mileage)) AS miles_since_last_oil_change
FROM vehicles v
JOIN maintenance_records mr ON v.vehicle_id = mr.vehicle_id
JOIN service_types st ON mr.service_id = st.service_id
WHERE LOWER(st.service_name) = 'oil change'
GROUP BY v.vin, v.make, v.model, v.year, v.current_mileage
HAVING (v.current_mileage - MAX(mr.mileage)) >= 5000;
    
SELECT 
    CONCAT(o.first_name,' ',o.last_name) AS Onwer_name,
    o.email,o.phone,o.address,
    COUNT(v.vehicle_id) AS number_of_vehicles
FROM owners o
JOIN ownership ow ON o.owner_id = ow.owner_id
JOIN vehicles v ON ow.vehicle_id = v.vehicle_id
WHERE ow.sale_date IS NULL
GROUP BY  Onwer_name,o.email, o.phone, o.address
ORDER BY number_of_vehicles DESC;

SELECT 
    v.vin,v.make,v.model,v.year,
    mr.service_date,mr.mileage,st.service_name,
    mr.cost,mr.service_notes,mr.service_center
FROM owners o
JOIN ownership ow ON o.owner_id = ow.owner_id
JOIN vehicles v ON ow.vehicle_id = v.vehicle_id
JOIN maintenance_records mr ON v.vehicle_id = mr.vehicle_id
LEFT JOIN service_types st ON mr.service_id = st.service_id
WHERE 
    o.first_name = 'John' AND o.last_name = 'Smith'
    AND ow.sale_date IS NULL
ORDER BY mr.service_date;
    
SELECT 
	CONCAT(o.first_name,' ',o.last_name) AS Onwer_name,
    o.email,o.phone,o.address,
    SUM(mr.cost) AS total_maintenance_cost
FROM maintenance_records mr
JOIN ownership ow ON mr.vehicle_id = ow.vehicle_id
JOIN owners o ON ow.owner_id = o.owner_id
WHERE 
    mr.service_date >= CURDATE() - INTERVAL 1 YEAR
    AND (ow.sale_date IS NULL OR mr.service_date <= ow.sale_date)
    AND mr.service_date >= ow.purchase_date
GROUP BY Onwer_name, o.email, o.phone,o.address
HAVING total_maintenance_cost > 500
ORDER BY total_maintenance_cost DESC;
    
SELECT 
    st.service_name,
    COUNT(mr.service_id) AS service_count
FROM maintenance_records mr
JOIN service_types st ON mr.service_id = st.service_id
GROUP BY st.service_name
ORDER BY service_count DESC
LIMIT 1;

SELECT 
    st.service_name,
    COUNT(mr.record_id) AS times_performed,
    AVG(mr.cost) AS average_service_cost
FROM maintenance_records mr
JOIN service_types st ON mr.service_id = st.service_id
GROUP BY st.service_name
ORDER BY average_service_cost DESC;
    
SELECT 
    v.vin,v.make,v.model,v.year,v.current_mileage
FROM vehicles v
LEFT JOIN maintenance_records mr 
ON 
	v.vehicle_id = mr.vehicle_id 
    AND mr.service_date >= CURDATE() - INTERVAL 6 MONTH
WHERE mr.record_id IS NULL;
    
SELECT 
    p.part_name,p.part_number,pu.quantity,pu.unit_price,
    (pu.quantity * pu.unit_price) AS total_cost
FROM maintenance_records mr
JOIN parts_used pu ON mr.record_id = pu.record_id
JOIN parts p ON pu.part_id = p.part_id
WHERE 
    mr.vehicle_id = 2
    AND pu.part_id IS NOT NULL;
    
SELECT 
    p.part_name,p.part_number,
    SUM(pu.quantity) AS total_quantity_replaced
FROM parts_used pu
JOIN parts p ON pu.part_id = p.part_id
WHERE pu.part_id IS NOT NULL
GROUP BY p.part_name, p.part_number
ORDER BY total_quantity_replaced DESC;
    
SELECT 
    v.vin,v.make,v.model,v.year,
    COUNT(mr.record_id) AS brake_service_count
FROM maintenance_records mr
JOIN vehicles v ON mr.vehicle_id = v.vehicle_id
JOIN service_types st ON mr.service_id = st.service_id
WHERE LOWER(st.service_name) LIKE '%brake%'
GROUP BY v.vehicle_id, v.vin, v.make, v.model, v.year
HAVING brake_service_count > 1;