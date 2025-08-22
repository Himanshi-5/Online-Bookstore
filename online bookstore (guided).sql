-- Create Tables
Create Table Books(Book_ID Serial Primary Key,
    Title Varchar(100),
    Author Varchar(100),
    Genre Varchar(50),
    Published_Year Int,
    Price Numeric(10, 2),
    Stock Int);
	
Create Table Customers(
    Customer_ID Serial Primary Key,
    Name Varchar(100),
    Email Varchar(100),
    Phone Varchar(15),
    City Varchar(50),
    Country Varchar(150));
	
Create Table Orders(
    Order_ID Serial Primary Key,
    Customer_ID Int References Customers(Customer_ID),
    Book_ID Int References Books(Book_ID),
    Order_Date Date,
    Quantity Int,
    Total_Amount Numeric(10, 2));
	
Select * from Books;
Select * from Customers;
Select * from Orders;

-- Import Data into Books Table
Copy Books from 'C:\Program Files\PostgreSQL\16\data\data ressource\Books.csv' csv header;

--Import Data into Customers Table
Copy Customers from 'C:\Program Files\PostgreSQL\16\data\data ressource\Customers.csv' csv header;

-- Import Data into Orders Table
Copy Orders from 'C:\Program Files\PostgreSQL\16\data\data ressource\Orders.csv' csv header;

--Basic Questions:

-- 1) Retrieve all books in the "Fiction" genre:
Select * from Books
where Genre = 'Fiction';

-- 2) Find books published after the year 1950:
Select * from Books
where Published_Year >1950;

-- 3) List all customers from the Canada:
Select * from Customers
where Country = 'Canada';

-- 4) Show orders placed in November 2023:
Select * from Orders
where Order_Date between '2023-11-01' and '2023-11-30';

-- 5) Retrieve the total stock of books available:
Select sum(Stock) as Total_Stock from Books;

-- 6) Find the details of the most expensive book:
Select * from Books
order by Price desc
limit 1;

-- 7) Show all customers who ordered more than 1 quantity of a book:
Select * from Orders
where Quantity >1;

-- 8) Retrieve all orders where the total amount exceeds $20:
Select * from Orders
where Total_amount>20;

-- 9) List all genres available in the Books table:
Select distinct Genre from Books;

-- 10) Find the book with the lowest stock:
Select * from Books
order by Stock limit 1;

-- 11) Calculate the total revenue generated from all orders:
Select sum(Total_amount) as Revenue
from Orders;

--Advance Questions:

-- 1) Retrieve the total number of books sold for each genre:
Select b.Genre, sum(o.Quantity) as Total_Books_sold
from Orders o
join Books b on o.book_id = b.book_id
group by b.Genre;

-- 2) Find the average price of books in the "Fantasy" genre:
Select avg(Price) as Avg_Price_Books
from Books
Where Genre='Fantasy';

-- 3) List customers who have placed at least 2 orders:
Select o.Customer_ID,c.name, count(o.Order_ID) as order_count
from Orders o
join Customers c on c.Customer_ID=o.Customer_ID
group by o.customer_id, c.name
having count(Order_id) >=2;

-- 4) Find the most frequently ordered book:
Select o.Book_ID, b.Title, count(o.Order_ID) as Order_count
from Orders o
join Books b on b.Book_ID=o.Book_ID
group by o.Book_ID, b.Title
order by Order_count desc limit 1;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
Select * from Books
where Genre='Fantasy'
order by Price desc limit 3;

-- 6) Retrieve the total quantity of books sold by each author:
Select b.Author,sum(o.Quantity) as Total_books_sold
from Orders o
join Books b on b.Book_ID=o.Book_ID
group by b.Author
order by Total_books_sold desc;

-- 7) List the cities where customers who spent over $30 are located:
Select Distinct c.City, o.Total_amount
from Orders o
join Customers c on o.Customer_ID=c.Customer_ID
where o.Total_amount>30;

-- 8) Find the customer who spent the most on orders:
Select c.Customer_ID,c.Name,sum(Total_amount) as Total_spent
from orders o
join Customers c on c.Customer_ID=o.Customer_ID
group by c.Customer_ID,Name
order by Total_spent desc limit 1;

--9) Calculate the stock remaining after fulfilling all orders:
Select b.Book_ID, b.Title, b.Stock, Coalesce(Sum(o.Quantity),0) as Order_quantity,  
b.Stock- Coalesce(sum(o.Quantity),0) as Remaining_quantity
from Books b
left join Orders o on b.Book_ID=o.Book_ID
group by b.Book_ID 
order by b.Book_ID;
