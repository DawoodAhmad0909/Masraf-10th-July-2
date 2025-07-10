# Masraf-10th-July-2
## Overview 

This database tracks a fleet of vehicles along with their owners, maintenance history, parts used, and fuel logs. It includes comprehensive information through the following tables: vehicles, owners, ownership, maintenance_records, service_types, parts, parts_used, and fuel_logs. Analytical queries were written to uncover patterns in service behavior, ownership, cost trends, and maintenance scheduling.

## Objectives 

To centralize all vehicle service records, parts replacements, and ownership details in a relational database for lifecycle management and resale documentation.

## Database Creation 
``` sql
CREATE DATABASE MD10thJ2_db;
USE MD10thJ2_db;
```
## Table Creation
### Table:vehicles
``` sql
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
```
### Table:owners
``` sql
CREATE TABLE owners(
    owner_id   INT PRIMARY KEY AUTO_INCREMENT,
    first_name TEXT,
    last_name  TEXT,
    email      TEXT,
    phone      TEXT,
    address    TEXT
);

SELECT * FROM owners ;
```
### Table:ownership
``` sql
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
```
### Table:service_types
``` sql
CREATE TABLE service_types(
    service_id                   INT PRIMARY KEY AUTO_INCREMENT,
    service_name                 TEXT,
    description                  TEXT,
    recommended_interval_miles   INT,
    recommended_interval_months  INT
);

SELECT * FROM service_types ;
```
### Table:maintenance_records
``` sql
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
```
### Table:parts
``` sql
CREATE TABLE parts(
    part_id                 INT PRIMARY KEY AUTO_INCREMENT,
    part_name               TEXT,
    part_number             TEXT,
    compatible_models       TEXT,
    average_lifespan_miles  INT
);

SELECT * FROM parts ;
```
### Table:parts_used
``` sql
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
```
### Table:fuel_logs
``` sql
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
```
## KEY Queries 

#### 1-List all vehicles with their make, model, year, and current mileage, sorted by newest first.
``` sql
SELECT 
        *
FROM vehicles
ORDER BY YEAR;
```
#### 2-Show the average mileage for each vehicle make in the database.
``` sql
SELECT 
        make,AVG(current_mileage) AS Current_mileage
FROM vehicles
GROUP BY make;
```
#### 3-Find all vehicles that use synthetic oil based on their maintenance records.
``` sql
SELECT 
        DISTINCT v.*
FROM vehicles v 
JOIN maintenance_records mr ON v.vehicle_id=mr.vehicle_id
WHERE LOWER(mr.service_notes) LIKE '%synthetic oil%';
```
#### 4-Display the complete service history for vehicle with VIN '1HGCM82633A123456'.
``` sql
SELECT 
    v.vin,v.make,v.model,v.year,
    mr.service_date,mr.mileage,st.service_name,
    mr.cost,mr.service_notes,mr.service_center
FROM vehicles v
JOIN maintenance_records mr ON v.vehicle_id = mr.vehicle_id
LEFT JOIN service_types st ON mr.service_id = st.service_id
WHERE v.vin = '1HGCM82633A123456'
ORDER BY mr.service_date;
```
#### 5-Calculate the total maintenance cost per vehicle, ordered from highest to lowest.
``` sql
SELECT 
    v.vin,v.make,v.model,v.year,
    SUM(mr.cost) AS total_maintenance_cost
FROM maintenance_records mr
JOIN vehicles v ON mr.vehicle_id = v.vehicle_id
GROUP BY v.vin, v.make, v.model, v.year
ORDER BY total_maintenance_cost DESC;
```
#### 6-Find vehicles that are due for an oil change (assuming 5,000 mile interval).
``` sql
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
```
#### 7-List all current vehicle owners with their contact information and the number of vehicles they own.
``` sql
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
```
#### 8-Show the maintenance history for all vehicles owned by 'John Smith'.
``` sql
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
```
#### 9-Find owners who have spent more than $500 on maintenance in the past year.
``` sql
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
```
#### 10-What is the most frequently performed service type across all vehicles?
``` sql
SELECT 
    st.service_name,
    COUNT(mr.service_id) AS service_count
FROM maintenance_records mr
JOIN service_types st ON mr.service_id = st.service_id
GROUP BY st.service_name
ORDER BY service_count DESC
LIMIT 1;
```
#### 11-Calculate the average cost of each type of service (oil change, tire rotation, etc.).
``` sql
SELECT 
    st.service_name,
    COUNT(mr.record_id) AS times_performed,
    AVG(mr.cost) AS average_service_cost
FROM maintenance_records mr
JOIN service_types st ON mr.service_id = st.service_id
GROUP BY st.service_name
ORDER BY average_service_cost DESC;
```
#### 12-Find vehicles that haven't had any maintenance in the last 6 months.
``` sql
SELECT 
    v.vin,v.make,v.model,v.year,v.current_mileage
FROM vehicles v
LEFT JOIN maintenance_records mr 
ON 
        v.vehicle_id = mr.vehicle_id 
    AND mr.service_date >= CURDATE() - INTERVAL 6 MONTH
WHERE mr.record_id IS NULL;
```
#### 13-List all parts that have been replaced for vehicle with ID 2.
``` sql
SELECT 
    p.part_name,p.part_number,pu.quantity,pu.unit_price,
    (pu.quantity * pu.unit_price) AS total_cost
FROM maintenance_records mr
JOIN parts_used pu ON mr.record_id = pu.record_id
JOIN parts p ON pu.part_id = p.part_id
WHERE 
    mr.vehicle_id = 2
    AND pu.part_id IS NOT NULL;
```
#### 14-Show the most commonly replaced parts across all vehicles.
``` sql
SELECT 
    p.part_name,p.part_number,
    SUM(pu.quantity) AS total_quantity_replaced
FROM parts_used pu
JOIN parts p ON pu.part_id = p.part_id
WHERE pu.part_id IS NOT NULL
GROUP BY p.part_name, p.part_number
ORDER BY total_quantity_replaced DESC;
```
#### 15-Find vehicles that have had brake service performed more than once.
``` sql
SELECT 
    v.vin,v.make,v.model,v.year,
    COUNT(mr.record_id) AS brake_service_count
FROM maintenance_records mr
JOIN vehicles v ON mr.vehicle_id = v.vehicle_id
JOIN service_types st ON mr.service_id = st.service_id
WHERE LOWER(st.service_name) LIKE '%brake%'
GROUP BY v.vehicle_id, v.vin, v.make, v.model, v.year
HAVING brake_service_count > 1;
```
## Conclusion 

This structured vehicle maintenance database offers powerful visibility into operational efficiency, service needs, and cost management. The insights gained from these queries enable proactive maintenance planning, owner engagement, and smarter inventory control for parts and services. It forms a strong foundation for a scalable fleet or automotive service management system.