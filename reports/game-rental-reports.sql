## Find all gaming labels in-stock that are by publisher “Ubisoft”.

SELECT title, name 
FROM Games_Library 
INNER JOIN Publishers ON Publishers.Identifier = Games_Library.Publisher_ID
HAVING Publishers.Name="Ubisoft" AND EXISTS (
	SELECT * 
	FROM Inventory 
	WHERE Inventory.Game_ID = Games_Library.Identifier
);

## Find customers who have currently rented <XYZ> title.

SELECT customers.First_Name
FROM Rental INNER JOIN customers ON customers.Identifier = Rental.Customer_ID
WHERE Returned_Date is NULL AND Rental.Inventory_Item_ID = (
	SELECT Inventory.Identifier 
	FROM Inventory INNER JOIN Games_Library ON Games_Library.Identifier = Inventory.Game_ID
	WHERE Title="Assassins Creed");

## Find the rental history of the customer name <XYZ>, what the customer has rented from X month to Y month.

SELECT First_Name, Rented_On_Date, Returned_Date, (
		SELECT Title
		FROM Games_Library 
		INNER JOIN Inventory ON Inventory.Game_ID = Games_Library.Identifier
		WHERE Inventory.Identifier = Rental.Inventory_Item_ID) as 'Title'
FROM customers 
INNER JOIN Rental ON Rental.Customer_ID = customers.Identifier
WHERE customers.First_Name="Jeffrey" 
	AND str_to_date('2015-01-01','%Y-%m-%d') <= Rental.Rented_On_Date 
	AND Rental.Rented_On_Date <= str_to_date('2018-12-01','%Y-%m-%d');

## Find the game that was sold the most in the last 6 month.

WITH rental_history AS (
	SELECT Title, COUNT(Rented_On_Date) as 'times_rented'
	FROM ((Rental INNER JOIN Inventory ON Rental.Inventory_Item_ID = Inventory.Identifier) 
	INNER JOIN Games_Library ON Inventory.Game_ID = Games_Library.Identifier)
	WHERE Rented_On_Date > current_date + INTERVAL -6 MONTH
	GROUP BY Title
)
SELECT title, times_rented
FROM rental_history
WHERE times_rented >= (SELECT MAX(times_rented) FROM rental_history);

## Display All gaming titles with their respective inventory count, display “--” for those games which do not have any copy in stock.

SELECT Games_Library.Title, CASE 
	WHEN COUNT(Inventory.Game_ID) = 0 THEN ('--')
	ELSE COUNT(Inventory.Game_ID)
	END as num_in_stock
FROM Inventory RIGHT JOIN Games_Library 
	ON Inventory.Game_ID = Games_Library.Identifier
GROUP BY Games_Library.Title;

## Display Fname, Contact, Gaming title for every customer who has currently rented a Title.

SELECT customers.First_Name, customers.Contact_Number, (
	SELECT Games_Library.Title 
	FROM Inventory INNER JOIN Games_Library ON Games_Library.Identifier = Inventory.Game_ID
	WHERE Inventory.Identifier = Rental.Inventory_Item_ID) as 'Game_Title'
FROM Rental INNER JOIN customers ON customers.Identifier = Rental.Customer_ID
WHERE Returned_Date is NULL;

## Find the total revenue of the last six month.

SELECT SUM(PAYMENT) as 'Total revenue'
FROM RENTAL
WHERE Rented_On_Date > current_date + INTERVAL -6 MONTH;

## Find the average revenue of the last six month.

SELECT AVG(PAYMENT)
FROM RENTAL 
WHERE Rented_On_Date > current_date + INTERVAL -6 MONTH;

## Find the gaming titles which are currently rented whose price is greater than X dollars.

SELECT Rental.Rented_On_Date, Games_Library.Title, Games_Library.price
FROM Rental, Games_Library 
WHERE Returned_Date is NULL 
	AND Games_Library.price > 90
	AND Games_Library.Identifier = (SELECT Game_ID FROM Inventory WHERE Inventory.Identifier = Rental.Inventory_Item_ID);

## Find the gaming title which is not been rented in the last X days or months.

<To Be Answered>

## Find the most busy days of the last month. Days on which significant business happenned.

WITH last_month_summary(Business_Dt, Labels_Rented) AS (
	SELECT Rented_On_Date, COUNT(Identifier)
	FROM  RENTAL
	WHERE MONTH(Rented_On_Date) = MONTH(current_date + INTERVAL -1 MONTH)
	GROUP BY Rented_On_Date)
SELECT Business_Dt, Labels_Rented
FROM last_month_summary
WHERE Labels_Rented = (SELECT MAX(Labels_Rented) FROM last_month_summary);

## Find the total amount of money on all titles which are currently rented.

SELECT SUM(PAYMENT) as Total
FROM RENTAL 
WHERE Returned_Date is NULL;

## Evaluate the of price of inventory, use the selling price of the titles.

SELECT SUM(Games_Library.Price) 
FROM Inventory 
INNER JOIN Games_Library ON Inventory.Game_ID = Games_Library.Identifier;

## Find the top 5 customers who bought the most business. (Customer who rented the most titles.)

SELECT Customers.Email, SUM(PAYMENT) AS 'Total'
FROM Customers INNER JOIN Rental ON Customers.Identifier = Rental.Customer_ID
GROUP BY Customers.Email
ORDER BY Total DESC
LIMIT 5;

