-- Commands to easily check table status
SELECT * FROM customers;
SELECT * FROM rental_records;
SELECT * FROM vehicles;

-- Q1: Add an entry showing customer 'Angel' has rented 'SBA1111A' from today for 10 days
INSERT INTO rental_records VALUES (
    NULL,
    'SBA1111A',
    (SELECT customer_id FROM customers WHERE name = 'Angel'),
    CURDATE(),
    DATE_ADD(CURDATE(), INTERVAL 10 DAY),
    NULL
);

-- Q2: Add an entry showing customer 'Kumar' has rented 'GA5555E' from tomorrow for 3 months
INSERT INTO rental_records VALUES (
    NULL,
    'GA5555E',
    (SELECT customer_id FROM customers WHERE name = 'Kumar'),
    CURDATE() + 1,
    DATE_ADD(CURDATE() + 1, INTERVAL 3 MONTH),
    NULL
);

-- Q3: List all rental records (start date, end date) with vehicle's registration number, brand, and customer name, sorted by vehicle's categories followed by start date.
SELECT start_date, end_date, veh_reg_no, vehicles.brand, customers.name
FROM rental_records
INNER JOIN vehicles USING (veh_reg_no)
INNER JOIN customers USING (customer_id)
ORDER BY vehicles.category, start_date;

-- Q4: List all the expired rental records (end_date before CURDATE()).
SELECT * FROM rental_records
WHERE end_date < CURDATE();

-- Q5: List the vehicles rented out on '2012-01-10' (not available for rental), in columns of vehicle registration no, customer name, start date and end date
SELECT veh_reg_no, customers.name, start_date, end_date
FROM rental_records
INNER JOIN customers USING (customer_id)
WHERE start_date < '2012-01-10' AND end_date > '2012-01-10';

-- Q6: List all vehicles rented out today, in columns registration number, customer name, start date, end date.
SELECT veh_reg_no, customers.name, start_date, end_date
FROM rental_records
INNER JOIN customers USING (customer_id)
WHERE start_date <= CURDATE() AND end_date >= CURDATE();

-- Q7: List the vehicles rented out (not available for rental) for the period from '2012-01-03' to '2012-01-18'
SELECT veh_reg_no, customers.name, start_date, end_date
FROM rental_records
INNER JOIN customers USING (customer_id)
WHERE start_date BETWEEN '2012-01-03' AND '2012-01-18' ;

-- Q8: List the vehicles (registration number, brand and description) available for rental (not rented out) on '2012-01-10'
SELECT veh_reg_no, brand, vehicles.desc
FROM vehicles
LEFT JOIN rental_records USING (veh_reg_no)
WHERE veh_reg_no NOT IN (
    SELECT veh_reg_no
    FROM rental_records
    WHERE start_date < '2012-01-10' AND end_date > '2012-01-10'
);

-- Q9: Similarly, list the vehicles available for rental for the period from '2012-01-03' to '2012-01-18'
SELECT veh_reg_no, brand, vehicles.desc
FROM vehicles
LEFT JOIN rental_records USING (veh_reg_no)
WHERE veh_reg_no NOT IN (
    SELECT veh_reg_no
    FROM rental_records
    WHERE end_date BETWEEN '2012-01-03' AND '2012-01-18'
);

-- Q10: Similarly, list the vehicles available for rental from today for 10 days.
SELECT veh_reg_no, brand, vehicles.desc
FROM vehicles
LEFT JOIN rental_records USING (veh_reg_no)
WHERE veh_reg_no NOT IN (
    SELECT veh_reg_no
    FROM rental_records
    WHERE start_date BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 10 DAY)
);