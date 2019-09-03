## Populating Publisher table:

DROP PROCEDURE IF EXISTS populate_publisher;
DELIMITER $$
CREATE PROCEDURE populate_publisher()
BEGIN
  DECLARE i INT DEFAULT 0;
  SET FOREIGN_KEY_CHECKS=0; TRUNCATE Publishers; SET FOREIGN_KEY_CHECKS=1;

  WHILE i < 1000000 DO
    INSERT INTO Publishers(Name, Country, Publisher_Desc) 
    VALUES (CONCAT(generate_fname(), i), generate_country_name(), "No Description");
    
    SET i = i + 1;
  END WHILE;
END$$
DELIMITER ;

## Populating Games_Library table:

DROP PROCEDURE IF EXISTS populate_games_library;
DELIMITER $$
CREATE PROCEDURE populate_games_library()
BEGIN
  DECLARE i INT DEFAULT 0;
  SET FOREIGN_KEY_CHECKS=0; TRUNCATE games_library; SET FOREIGN_KEY_CHECKS=1;
  WHILE i < 1000000 DO
    INSERT INTO Games_Library(Title, Release_Date, Size_In_MB, Publisher_ID, Copies_Available, Price) 
    VALUES (
    	CONCAT("Gaming_Title_",i), 
    	FROM_UNIXTIME(UNIX_TIMESTAMP('2014-01-01 01:00:00')+FLOOR(RAND()*31536000)),
    	FLOOR(ROUND(RAND()*100,2)),
    	i+1,
	FLOOR(ROUND(RAND()*100,2)),
	ROUND(RAND()*100,2));
    
    SET i = i + 1;
  END WHILE;
END$$
DELIMITER ;

## Populating Inventory table:

DROP PROCEDURE IF EXISTS populate_inventory;
DELIMITER $$
CREATE PROCEDURE populate_inventory()
BEGIN
  DECLARE i INT DEFAULT 0;
  SET FOREIGN_KEY_CHECKS=0; TRUNCATE inventory; SET FOREIGN_KEY_CHECKS=1;

  WHILE i < 1000000 DO
    INSERT INTO inventory(Barcode, Game_ID) 
    VALUES (CONCAT("Gaming_", i, "_BAR"), i+1);
    
    SET i = i + 1;
  END WHILE;
END$$
DELIMITER ;

## Populating Audit table:

DROP PROCEDURE IF EXISTS populate_audit;
DELIMITER $$
CREATE PROCEDURE populate_audit()
BEGIN
  DECLARE i INT DEFAULT 0;
  SET FOREIGN_KEY_CHECKS=0; TRUNCATE Audit; SET FOREIGN_KEY_CHECKS=1;

  WHILE i < 1000000 DO
    INSERT INTO Audit(Game_ID, Audited_On, Copies_Stocked) 
    VALUES (i+1, FROM_UNIXTIME(UNIX_TIMESTAMP('2014-01-01 01:00:00')+FLOOR(RAND()*31536000)), FLOOR(ROUND(RAND()*100,2)));
    
    SET i = i + 1;
  END WHILE;
END$$
DELIMITER ;

## Populating Customers table:

DROP PROCEDURE IF EXISTS populate_customers;
DELIMITER $$
CREATE PROCEDURE populate_customers()
BEGIN
  DECLARE i INT DEFAULT 0;
  SET FOREIGN_KEY_CHECKS=0; TRUNCATE Customers; SET FOREIGN_KEY_CHECKS=1;

  WHILE i < 1000000 DO
    INSERT INTO Customers(First_Name, Last_Name, Contact_Number, Email, Address) 
    VALUES (
    	generate_fname(),
    	generate_lname(),
    	i+1,
      CONCAT("randomEmail_", i+1, "@gmail.com"),
      CONCAT("Street ", i+1)
    	);
    
    SET i = i + 1;
  END WHILE;
END$$
DELIMITER ;

## Populating Rental table:

DROP PROCEDURE IF EXISTS populate_rental;
DELIMITER $$
CREATE PROCEDURE populate_rental()
BEGIN
  DECLARE i INT DEFAULT 0;
  DECLARE rented_on_date_var DATE;
  SET FOREIGN_KEY_CHECKS=0; TRUNCATE rental; SET FOREIGN_KEY_CHECKS=1;

  WHILE i < 1000000 DO
    SET rented_on_date_var = FROM_UNIXTIME(UNIX_TIMESTAMP('2014-01-01 01:00:00')+FLOOR(RAND()*31536000));
    INSERT INTO Rental(Inventory_Item_ID, Customer_ID, Payment, Rented_On_Date, Returned_Date) 
    VALUES (
      i+1,
      i+1,
      ROUND(RAND()*100,2),
      rented_on_date_var,
      DATE_ADD(rented_on_date_var, INTERVAL FLOOR(ROUND(RAND()*100,2)) DAY)
      );
    
    SET i = i + 1;
  END WHILE;
END$$
DELIMITER ;
