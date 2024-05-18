-- This file does not create the database and tables provided by the course's lecture.
-- You may visit the course page to evaluate the data and the introductory code provided by Meta's Advanced MySQL lecture: 
-- https://www.coursera.org/learn/advanced-mysql-topics/ungradedLab/yuPd1/conduct-a-data-analysis-for-a-client-persona.

-- TASK 1


CREATE FUNCTION FindAverageCost(yearinput INT) RETURNS DECIMAL(5,2) DETERMINISTIC RETURN(SELECT AVG(Cost) FROM Orders WHERE YEAR(DATE) = yearinput);

SELECT FINDAverageCost(2022);

-- TASK 2 


-- Use DELIMITER to denote the start and end of the stored procedure 
DELIMITER //

CREATE PROCEDURE EvaluateProduct0(OUT TotalItem_2020 INT, OUT TotalItem_2021 INT, OUT TotalItem_2022 INT) BEGIN SELECT COUNT(Quantity) INTO TotalItem_2020 FROM Orders WHERE (ProductID = "P1" AND YEAR(Date) = 2020); SELECT COUNT(Quantity) INTO TotalItem_2021 FROM Orders WHERE (ProductID = "P1" AND YEAR(Date)=2021); SELECT COUNT(Quantity) INTO TotalItem_2022 FROM Orders WHERE (ProductID = "P1" AND YEAR(Date) = 2022);  END // 

DELIMITER ;

-- @TotalItem_2020,@TotalItem_2021,@TotalItem_2022 are OUT parameters. 
CALL EvaluateProduct0(@TotalItem_2020,@TotalItem_2021,@TotalItem_2022);

-- Use SELECT to return the output
SELECT @TotalItem_2020,  @TotalItem_2021,  @TotalItem_2022;


-- TASK 3


CREATE TRIGGER UpdateAudit AFTER INSERT ON Orders FOR EACH ROW INSERT INTO Audit(OrderDateTime) VALUES (CONCAT(CURRENT_DATE(), CURRENT_TIME()));


-- TASK 4 


-- INNER JOIN used to combine common results from multible tables. 
SELECT C.FullName, A.Street, A.County FROM Addresses AS A INNER JOIN Clients AS C ON A.AddressID = C.AddressID UNION SELECT E.FullName, A.Street, A.County FROM Addresses AS A INNER JOIN Employees AS E ON A.AddressID = E.AddressID ORDER BY Street;



-- TASK 5 


-- USE UNION to combine results from differnt years
SELECT CONCAT(SUM(Cost), "  (2020)") AS "P2 Product Quantity Sold" FROM Orders WHERE ProductID = "P2" AND YEAR(Date) = 2020 UNION SELECT CONCAT(SUM(Cost),  "  (2021)") FROM Orders WHERE  ProductID  = "P2" AND YEAR(Date) = 2021 UNION SELECT CONCAT(SUM(Cost), " (2022)" ) FROM Orders WHERE  ProductID  = "P2" AND YEAR(Date)= 2022 ;



-- TASK 6


SELECT Clients.ClientID, Clients.FullName,  Clients.ContactNumber, Activity.Properties->> '$.ProductID' FROM Clients INNER JOIN Activity ON Clients.ClientID = Activity.Properties->> '$.ClientID';



-- TASK 7



DELIMITER //

-- DECLARE is used to define variables
CREATE PROCEDURE GetProfit(IN product_id VARCHAR(20), IN year_input INT) BEGIN DECLARE profit DEC(6,2) DEFAULT 0.0; DECLARE sold_quantity, buy_price, sell_price INT DEFAULT 0; SELECT SUM(Quantity) INTO sold_quantity FROM Orders WHERE ProductID = product_id AND YEAR(Date) = year_input; SELECT BuyPrice INTO buy_price FROM Products WHERE ProductID = product_id; SELECT SellPrice INTO sell_price FROM Products WHERE ProductID = product_id; SET profit = (sell_price * sold_quantity) - (buy_price * sold_quantity); SELECT profit; END // 

DELIMITER ;


-- TASK 8


-- Create virtual table using CREATE VIEW statement
CREATE VIEW DATASUMMARY AS SELECT Clients.FullName, Clients.ContactNumber, Addresses.County, Products.ProductName, Orders.ProductID, Orders.Cost, Orders.Date FROM Clients INNER JOIN Addresses ON Clients.AddressID = Addresses.AddressID INNER JOIN Orders ON Clients.ClientID = Orders.ClientID INNER JOIN Products ON Orders.ProductID = Products.ProductID;

SELECT * FROM DATASUMMARY;
