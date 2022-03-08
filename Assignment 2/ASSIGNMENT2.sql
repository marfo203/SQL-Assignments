#Emilia Bylund Mansson, emiby190
#Martin Forsberg, marfo203

#Number 1
SELECT *
FROM jbemployee; 

#Number 2
SELECT name 
FROM jbdept 
ORDER BY name ASC; 

#Number 3
SELECT name
FROM jbparts
WHERE qoh=0; 

#Number 4
SELECT name
FROM jbemployee 
WHERE salary BETWEEN 9000  AND 10000; 

#Number 5
SELECT name, startyear-birthyear
FROM jbemployee; 

#Number 6
SELECT name
FROM jbemployee
WHERE name LIKE '%son,%'; 

#Number 7
SELECT name 
FROM jbitem
WHERE supplier = 
(SELECT id
FROM jbsupplier
WHERE name = 'Fisher-Price'); 

#Number 8
SELECT jbitem.name
FROM jbitem INNER JOIN jbsupplier ON jbitem.supplier = jbsupplier.id
WHERE jbsupplier.name = 'Fisher-Price'; 

# Number 9
SELECT jbcity.name
FROM jbcity
WHERE jbcity.id = ANY
(SELECT jbsupplier.city
FROM jbsupplier); 

#Number 10
SELECT name, color
FROM jbparts
WHERE weight > ANY
(SELECT weight
FROM jbparts
WHERE name = 'card reader'); 

#Number 11
SELECT S.name, S.color
FROM jbparts E INNER JOIN jbparts S ON E.name = 'card reader'
WHERE S.weight > E.weight; 

#Number 12
SELECT AVG(weight) 
FROM jbparts
WHERE color = 'black'; 

#Number 13
SELECT jbsupplier.name, SUM(jbsupply.quan*jbparts.weight)
FROM jbsupplier INNER JOIN jbsupply ON jbsupplier.id = jbsupply.supplier
INNER JOIN jbparts ON jbsupply.part = jbparts.id
WHERE jbsupplier.city = ANY
(SELECT jbcity.id
FROM jbcity 
WHERE jbcity.state = 'Mass')
GROUP BY jbsupplier.name; 

# Number 14
DROP TABLE IF EXISTS newitems; 

CREATE TABLE newitems (
	id INT NOT NULL,
    name VARCHAR(20), 
	dept INT NOT NULL,
    price INT,
    qoh INT,
    supplier INT NOT NULL, 
	CONSTRAINT pk_newitem PRIMARY KEY(id),
    CONSTRAINT fk_newitem FOREIGN KEY(dept) REFERENCES jbdept(id),
    CONSTRAINT fk_newitmsupplier FOREIGN KEY(supplier) REFERENCES jbsupplier(id)); 

INSERT INTO newitems  
SELECT *
FROM jbitem
WHERE price < 
(SELECT AVG(price)
FROM jbitem); 

#Number 15
DROP VIEW IF EXISTS newitem_view; 

CREATE VIEW newitem_view AS
SELECT name 
FROM newitems; 

#Number 16
-- The view is dynamic because every time something changes in the data the view is updated, it changes dynamically. 
-- It is possible to restrict access in a view due to the possibility of specifiying what each user needs to see. 

-- The table is static becuase the user activly needs to tell the data to change.  
    
#Number 17
DROP VIEW IF EXISTS debit_view; 

CREATE VIEW debit_view AS
SELECT jbsale.debit, SUM(jbitem.price*jbitem.qoh)
FROM jbsale, jbitem
WHERE jbsale.item = ANY
(SELECT jbitem.id
FROM jbitem)
GROUP BY jbsale.debit;

#Number 18
DROP VIEW IF EXISTS debit_viewtwo; 

CREATE VIEW debit_viewtwo AS
SELECT jbsale.debit, SUM(jbitem.price*jbitem.qoh)
FROM jbsale LEFT JOIN jbitem ON jbsale.item = jbitem.id 
GROUP BY jbsale.debit; 

-- We use LEFT JOIN because we want to get everything from the jbsale but only the corresponding 
-- tuples from jbitem. 

#Number 19 
-- DELETE FROM jbsale WHERE jbsale.item = ANY
-- (SELECT jbitem.id
-- FROM jbitem 
-- WHERE jbitem.supplier = ANY 
-- (SELECT jbcity.id
-- FROM jbcity
-- WHERE jbcity.name = 'Los Angeles')); 

-- DELETE FROM jbitem WHERE jbitem.supplier = ANY 
-- (SELECT jbcity.id
-- FROM jbcity
-- WHERE jbcity.name = 'Los Angeles'); 

-- DELETE FROM jbsupplier WHERE jbsupplier.city = ANY
-- (SELECT jbcity.id
-- FROM jbcity
-- WHERE jbcity.name = 'Los Angeles'); 

-- To avoid a foreign key contraint we needed to remove the tuples related to the suppliers.  

#Number 20
DROP VIEW IF EXISTS jbsale_supply CASCADE;

CREATE VIEW jbsale_supply(supplier, item, quantity) AS
SELECT jbsupplier.name, jbitem.name, jbsale.quantity
FROM jbsupplier LEFT JOIN jbitem ON
jbsupplier.id = jbitem.supplier
LEFT JOIN jbsale ON 
jbitem.id = jbsale.item; 

SELECT supplier, sum(quantity) 
FROM jbsale_supply
GROUP BY supplier
ORDER BY sum(quantity) desc; 



    



    
    




 