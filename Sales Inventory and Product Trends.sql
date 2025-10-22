Create Database Sales_Inventory_And_Product_trends;


Use Sales_Inventory_And_Product_trends;

CREATE TABLE Supplier (
  SupplierID INT PRIMARY KEY,
  SupplierName VARCHAR(100),
  ContactName VARCHAR(50),
  City VARCHAR(50)
);

CREATE TABLE Product (
  ProductID INT PRIMARY KEY,
  ProductName VARCHAR(100),
  Category VARCHAR(50),
  Price DECIMAL(10, 2),
  SupplierID INT,
  FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID)
);

CREATE TABLE Inventory (
  InventoryID INT PRIMARY KEY,
  ProductID INT,
  StockQuantity INT,
  ReorderLevel INT,
  FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

CREATE TABLE Sales (
  SaleID INT PRIMARY KEY,
  ProductID INT,
  SaleDate DATE,
  QuantitySold INT,
  TotalSaleAmount DECIMAL(12, 2),
  FOREIGN KEY (ProductID) REFERENCES Product(ProductID)
);

INSERT INTO Supplier VALUES
(1, 'Global Supplies', 'Alice Green', 'New York'),
(2, 'Tech Corp', 'Bob White', 'Chicago'),
(3, 'Office Essentials', 'Carol Green', 'Dallas'),
(4, 'Home Comforts', 'David Black', 'Atlanta'),
(5, 'Global Electronics', 'Emily White', 'Seattle');

INSERT INTO Product VALUES
(101, 'Laptop', 'Electronics', 1200.00, 2),
(102, 'Smartphone', 'Electronics', 800.00, 2),
(103, 'Office Chair', 'Furniture', 150.00, 1),
(104, 'Desk Lamp', 'Furniture', 45.00, 1),
(105, 'Printer', 'Electronics', 300.00, 3),
(106, 'Monitor', 'Electronics', 250.00, 3),
(107, 'Filing Cabinet', 'Furniture', 200.00, 4),
(108, 'Desk Organizer', 'Furniture', 25.00, 4),
(109, 'Webcam', 'Electronics', 85.00, 5),
(110, 'Wireless Mouse', 'Electronics', 40.00, 5);

INSERT INTO Inventory VALUES
(1, 101, 50, 10),
(2, 102, 200, 30),
(3, 103, 80, 15),
(4, 104, 150, 20),
(5, 105, 40, 10),
(6, 106, 60, 15),
(7, 107, 25, 8),
(8, 108, 100, 30);

INSERT INTO Sales VALUES
(1, 101, '2025-06-01', 5, 6000.00),
(2, 102, '2025-06-01', 10, 8000.00),
(3, 103, '2025-06-01', 3, 450.00),
(4, 104, '2025-06-01', 7, 315.00),
(5, 101, '2025-07-15', 8, 9600.00),
(6, 102, '2025-07-15', 15, 12000.00),
(7, 105, '2025-08-10', 6, 1800.00),
(8, 106, '2025-08-15', 10, 2500.00),
(9, 107, '2025-08-20', 3, 600.00),
(10, 108, '2025-08-25', 20, 500.00),
(11, 101, '2025-08-01', 20, 24000.00),
(12, 102, '2025-08-02', 15, 12000.00),
(13, 103, '2025-08-03', 5, 750.00),
(14, 104, '2025-08-04', 13, 585.00),
(15, 105, '2025-08-05', 15, 4500.00),
(16, 106, '2025-08-06', 11, 2750.00),
(17, 107, '2025-08-07', 3, 600.00),
(18, 108, '2025-08-08', 3, 75.00),
(19, 109, '2025-08-09', 10, 850.00),
(20, 110, '2025-08-10', 14, 560.00),
(21, 101, '2025-08-11', 4, 4800.00),
(22, 102, '2025-08-12', 1, 800.00),
(23, 103, '2025-08-13', 18, 2700.00),
(24, 104, '2025-08-14', 18, 810.00),
(25, 105, '2025-08-15', 11, 3300.00),
(26, 106, '2025-08-16', 6, 1500.00),
(27, 107, '2025-08-17', 3, 600.00),
(28, 108, '2025-08-18', 4, 100.00),
(29, 109, '2025-08-19', 11, 935.00),
(30, 110, '2025-08-20', 2, 80.00),
(31, 101, '2025-08-21', 10, 12000.00),
(32, 102, '2025-08-22', 13, 10400.00),
(33, 103, '2025-08-23', 13, 1950.00),
(34, 104, '2025-08-24', 1, 45.00),
(35, 105, '2025-08-25', 4, 1200.00),
(36, 106, '2025-08-26', 20, 5000.00),
(37, 107, '2025-08-27', 20, 4000.00),
(38, 108, '2025-08-28', 14, 350.00),
(39, 109, '2025-08-29', 10, 850.00),
(40, 110, '2025-08-30', 9, 360.00);



-- Determine the total number of Product in the dataset.

Select count(*) from product;

-- Determine the total number of Category in the dataset.

Select count(Distinct Category) from product; 

-- Determine the total number of Sales in the dataset.

Select count(*) from Sales;

-- 1. List products with stock below reorder level

Select P.ProductID, P.ProductName
From Product P
Join Inventory I on I.productID=P.ProductID
where I.StockQuantity<I.ReorderLevel;

-- 2. Total sales amount and quantity sold by product category

Select P.Category, Sum(S.TotalSaleAmount) as TotalSales, Sum(S.quantitySold) as TotalQuantity
From Sales S
Join Product P on P.productID=S.productID
Group By P.category;

-- 3. Monthly sales trend for each product

Select P.ProductName, Date_Format(S.SaleDate, '%Y-%m') as SaleMonth, SUM(s.QuantitySold) AS TotalQuantitySold,Sum(S.TotalSaleAmount) AS Revenue
From Sales S
Join Product P on P.productID=S.productID
Group By P.productName, SaleMonth
Order By P.productName;

-- 4. Top 3 best-selling products by quantity sold

Select P.productName, Sum(QuantitySold) AS SoldQty
from product P
join Sales S on P.productID = S.ProductID
Group By P.productName
order by Sum(QuantitySold) Desc
Limit 3;

-- 5. Supplier-wise sales performance with ranking

Select S1.SupplierName, sum(S2.TotalSaleAmount) AS TotalSale,
	Rank() Over(order By sum(S2.totalsaleamount) Desc) AS Rnk
From Supplier S1
Join Product P on P.supplierID = S1.supplierID
Join Sales S2 on S2.productID = P.productID
Group By S1.SupplierName;

-- 6. Calculate average monthly sales per product

Select P.productName, round(Avg(T.TotalSale),2) AS AvgMonthlySale
From(
	Select productID, Month(SaleDate) AS MonthName, Sum(TotalSaleAmount) as TotalSale
	From Sales
	Group By ProductID, MonthName
    ) AS T
Join product P on P.productID=T.ProductID
Group by P.productName;


-- 7.  Identify products with increasing sales trend over the last 3 months

WITH MonthlySales AS (
  SELECT 
    ProductID,
    month(SaleDate) AS SaleMonth,
    SUM(QuantitySold) AS QuantitySold
  FROM Sales
  GROUP BY ProductID, SaleMonth
),
RankedSales AS (
  SELECT 
    ProductID, SaleMonth, QuantitySold,
    ROW_NUMBER() OVER (PARTITION BY ProductID ORDER BY SaleMonth) AS rn
  FROM MonthlySales
)
SELECT DISTINCT p.ProductName
FROM RankedSales r1
JOIN RankedSales r2 ON r1.ProductID = r2.ProductID AND r2.rn = r1.rn + 1
JOIN RankedSales r3 ON r2.ProductID = r3.ProductID AND r3.rn = r2.rn + 1
JOIN Product p ON r1.ProductID = p.ProductID
WHERE r1.QuantitySold < r2.QuantitySold AND r2.QuantitySold < r3.QuantitySold;

-- 8. Calculate percentage contribution to total sales by each product category

With Total_Sales AS(
	Select Sum(totalsaleamount) as TotalSale
    From Sales),
Category_Sale as(
	Select P.Category, sum(S.Totalsaleamount) as CategorySale
    From Product P
    Join Sales S on P.productID=S.productID
    Group by P.category)
Select Category, Round((CategorySale/TotalSale)*100,2) as Contribution
From Category_Sale
Join Total_Sales;

-- 9. Find products not sold in the last 6 months

Select P.ProductID
From Product P
left Join Sales S on P.productID=S.ProductID
And SaleDate>= current_date - interval 6 Month
where S.productID is null;

-- 10. Find suppliers with products having stock greater than 100 unit

SELECT DISTINCT sup.SupplierName, p.ProductName, i.StockQuantity
FROM Supplier sup
JOIN Product p ON sup.SupplierID = p.SupplierID
JOIN Inventory i ON p.ProductID = i.ProductID
WHERE i.StockQuantity > 100;