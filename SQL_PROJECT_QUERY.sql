CREATE DATABASE Online_BookStore;
USE Online_BookStore;

CREATE TABLE Books(
Book_ID INT PRIMARY KEY,
Title VARCHAR(100),
Author VARCHAR(50),
Genre VARCHAR(20),
Published_Year INT,
Price FLOAT,
Stock INT);

-- IMPORT DATA INTO BookS TABLE
BULK INSERT Books
FROM 'G:/SQL PROJECT (YT)/Books.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A'
);


SELECT * FROM Books; 

CREATE TABLE Customers(
Customer_ID	INT PRIMARY KEY,
Name VARCHAR(100),
Email VARCHAR(100),
Phone INT,
City VARCHAR(100),
Country VARCHAR(100)
);

-- IMPORT DATA INTO Customers TABLE
BULK INSERT Customers
FROM 'G:\SQL PROJECT (YT)\Customers.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A'
);

SELECT * FROM Customers;

CREATE TABLE Orders(
Order_ID INT PRIMARY KEY,
Customer_ID	INT REFERENCES Customers(Customer_ID),
Book_ID	INT REFERENCES Books(Book_ID),
Order_Date	DATE,
Quantity INT,
Total_Amount DECIMAL(10,2)
);



-- IMPORT DATA INTO Orders TABLE
BULK INSERT Orders
FROM 'G:\SQL PROJECT (YT)\Orders.csv'
WITH
(
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0A'
);
SELECT * FROM Orders;


-- 1) Retrieve all books in the "Fiction" genre:
SELECT * FROM Books
WHERE Genre = 'Fiction';


-- 2) Find books published after the year 1950:
SELECT * FROM Books
WHERE Published_Year > 1950;

 --3) List all customers from the Denmark:
SELECT * FROM Customers
WHERE Country = 'Denmark';

-- 4) Show orders placed in November 2023:
SELECT * FROM Orders
WHERE Order_Date BETWEEN '2023-11-01' AND '2023-11-30';

-- 5) Retrieve the total stock of books available:
SELECT SUM(Stock) AS Total_Stocks
FROM Books;

-- 6) Find the details of the most expensive book:
SELECT TOP 1 *
FROM Books
ORDER BY Price DESC;

 --7) Show all customers who ordered more than 1 quantity of a book:
 SELECT C.Name, O.Quantity
 FROM Customers AS C
 INNER JOIN Orders AS O
 ON C.Customer_ID	= O.Customer_ID	
 WHERE Quantity >1;
   

 -- 9) List all genres available in the Books table:
SELECT DISTINCT genre FROM Books;

-- 10) Find the book with the lowest stock:
SELECT TOP 1 * FROM Books
ORDER BY Stock ASC;

-- 11) Calculate the total revenue generated from all orders:
SELECT SUM(B.Price*O.Quantity) AS Total_Revenue
FROM Books AS B
INNER JOIN Orders AS O
ON B.Book_ID=O.Book_ID ;

-- Advance Questions : 

-- 1) Retrieve the total number of books sold for each genre:

SELECT DISTINCT B.Genre, SUM(O.Quantity)  AS To_Books_Sold
FROM Books AS B 
INNER JOIN Orders AS O
ON B.Book_ID = O.Book_ID
GROUP BY B.Genre;

-- 2) Find the average price of books in the "Fantasy" genre:

SELECT  AVG(Price) AS AVG_PRICE
FROM Books
WHERE Genre = 'Fantasy';


-- 3) List customers who have placed at least 2 orders:

SELECT o.customer_id, c.name, COUNT(o.Order_id) AS ORDER_COUNT
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
GROUP BY o.customer_id, c.name
HAVING COUNT(Order_id) >=2;


-- 4) Find the most frequently ordered book:
SELECT B.Title, COUNT(O.Order_ID) AS ORDER_COUNT
FROM Books AS B
JOIN Orders AS O
ON B.Book_ID=O.Book_ID
GROUP BY B.Title,O.Book_ID
ORDER BY ORDER_COUNT DESC ;


-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
SELECT TOP 3 B.Title, B.Price AS Expensive_Book
FROM Books AS B
WHERE Genre='Fantasy'
ORDER BY Price DESC;

-- 6) Retrieve the total quantity of books sold by each author:
SELECT B.Author,SUM(O.Quantity) AS Total_quantity
FROM Books AS B
JOIN Orders AS O
ON B.Book_ID = O.Book_ID
GROUP BY B.Author
ORDER BY Total_quantity DESC ;

-- 7) List the cities where customers who spent over $30 are located:
 SELECT DISTINCT C.City,O.Total_Amount 
 FROM Customers AS C
 JOIN Orders AS O
 ON C.Customer_ID =O.Customer_ID
 WHERE O.Total_Amount >30;


 -- 8) Find the customer who spent the most on orders:
 SELECT TOP 1 C.Name,SUM(O.Total_Amount) AS TOTAL_SPENT
 FROM Customers AS C
 JOIN Orders AS O
 ON C.Customer_ID = O.Customer_ID
 GROUP BY C.Name
 ORDER BY TOTAL_SPENT DESC ;

 --9) Calculate the stock remaining after fulfilling all orders:

 SELECT B.Book_ID,
 B.Title,
 B.Stock AS Original_Stock,
 SUM(O.Quantity) AS Total_ordered ,
 B.Stock - SUM(O.Quantity) AS Remaining_Stock
 FROM Books AS B
 INNER JOIN Orders AS O
 ON B.Book_ID = O.Book_ID
 GROUP BY B.Book_ID, B.Stock,B.Title;



  