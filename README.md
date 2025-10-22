## Project Overview

**Project Title**: Sales Inventory and Product Trends 
**Level**: Beginner  
**Database**: `Sales_Inventory_And_Product_trends`

This project contains a comprehensive SQL database and query set for managing and analyzing sales, inventory, products, and suppliers data. It demonstrates key database operations such as table creation, data insertion, and complex analytics queries related to product stock, sales performance, monthly trends, and supplier rankings.

## Objectives

1. **Set up a database**: Build a database to store Supplier, Product, Inventory, Sales metrics.
2. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
3. **Data Analysis**: This project aims to provide insightful analytics on sales performance, inventory management, and supplier contributions, enabling data-driven decisions to optimize stock levels, identify best-selling products, and improve overall supply chain efficiency.

## Project Structure

### 1. Database Structure

**Supplier**: Stores supplier details including SupplierID, SupplierName, ContactName, and City.

**Product**: Contains product details like ProductID, ProductName, Category, Price, and SupplierID (foreign key).

**Inventory**: Tracks product stock quantities and reorder levels per product.

**Sales**: Records sales transactions including SaleID, ProductID, SaleDate, QuantitySold, and TotalSaleAmount.

```sql 
Create Database Sales_Inventory_And_Product_trends;

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
```

### 2. Data Exploration & Cleaning

- **Product Count**: Determine the total number of Product in the dataset.
- **Category Count**: Determine the total number of Category in the dataset.
- **Total Sale Count**: Determine the total number of Sales in the dataset.
  ```

### 3. Data Analysis & Findings

The following SQL queries were developed to analyze Employee performance:

1. **List products with stock below reorder level**:
```sql
Select P.ProductID, P.ProductName
From Product P
Join Inventory I on I.productID=P.ProductID
where I.StockQuantity<I.ReorderLevel;
```

2. **Total sales amount and quantity sold by product category**:
```sql
Select P.Category, Sum(S.TotalSaleAmount) as TotalSales, Sum(S.quantitySold) as TotalQuantity
From Sales S
Join Product P on P.productID=S.productID
Group By P.category;
```

3. **Monthly sales trend for each product**:
```sql
Select P.ProductName, Date_Format(S.SaleDate, '%Y-%m') as SaleMonth, SUM(s.QuantitySold) AS TotalQuantitySold,Sum(S.TotalSaleAmount) AS Revenue
From Sales S
Join Product P on P.productID=S.productID
Group By P.productName, SaleMonth
Order By P.productName;
```

4. **Top 3 best-selling products by quantity sold**:
```sql
Select P.productName, Sum(QuantitySold) AS SoldQty
from product P
join Sales S on P.productID = S.ProductID
Group By P.productName
order by Sum(QuantitySold) Desc
Limit 3;
```

5. **Find employees who earn more than their manager**:
```sql
Select S1.SupplierName, sum(S2.TotalSaleAmount) AS TotalSale,
	Rank() Over(order By sum(S2.totalsaleamount) Desc) AS Rnk
From Supplier S1
Join Product P on P.supplierID = S1.supplierID
Join Sales S2 on S2.productID = P.productID
Group By S1.SupplierName;
```

6. **Calculate average monthly sales per product**:
```sql
Select P.productName, round(Avg(T.TotalSale),2) AS AvgMonthlySale
From(
	Select productID, Month(SaleDate) AS MonthName, Sum(TotalSaleAmount) as TotalSale
	From Sales
	Group By ProductID, MonthName
    ) AS T
Join product P on P.productID=T.ProductID
Group by P.productName;
```

7. **Identify products with increasing sales trend over the last 3 monthsIdentify products with increasing sales trend over the last 3 months**:
```sql
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
```

8. **Calculate percentage contribution to total sales by each product category**:
```sql
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
```

9. **Find products not sold in the last 6 months**:
```sql
Select P.ProductID
From Product P
left Join Sales S on P.productID=S.ProductID
And SaleDate>= current_date - interval 6 Month
where S.productID is null;
```

10. **Find suppliers with products having stock greater than 100 unit**:
```sql
SELECT DISTINCT sup.SupplierName, p.ProductName, i.StockQuantity
FROM Supplier sup
JOIN Product p ON sup.SupplierID = p.SupplierID
JOIN Inventory i ON p.ProductID = i.ProductID
WHERE i.StockQuantity > 100;
```
## Findings

- **Stock Quantity and Reorder Level**: Products with ProductIDs having stock quantity close to or below reorder levels require immediate attention for restocking to avoid potential stockouts and lost sales.
- **Sales Performance**: ProductIDs linked with higher total sales quantity and revenue indicate top performing products. These products significantly contribute to overall revenue and require consistent inventory availability.
- **Monthly Sales Trends**: Analyzing monthly sales volumes for each ProductID reveals seasonal variations and demand peaks, facilitating better forecasting and inventory planning.
- **Best-Selling Products**: The highest-ranked ProductIDs by quantity sold highlight customer preferences and popular categories, useful for targeted marketing and procurement strategies.
- **Non-Selling Products**: Products that have no sales in the last six months may be candidates for discontinuation or require promotional efforts to boost demand.
- **Sales Growth Trends**: ProductIDs showing consistent month-over-month sales increases present opportunities for scaling inventory and expanding sales operations.


## Conclusion

The analysis of the Sales Inventory and Product Trends database reveals critical insights for inventory management and sales optimization. Maintaining appropriate stock levels for top-selling products ensures uninterrupted sales and customer satisfaction. Monitoring monthly sales patterns allows for proactive inventory adjustments and better demand forecasting. Identifying underperforming products facilitates resource reallocation towards more profitable items. Supplier performance analysis helps prioritize collaboration with high-revenue contributors. Overall, data-driven decisions based on this analysis can enhance supply chain efficiency, optimize inventory costs, and maximize revenue growth.

## How to Use

1. **Clone the Repository**: Clone this project repository from GitHub.
2. **Set Up the Database**: Run the SQL scripts provided in the `Sales Inventory and Product Trends.sql` file to create and populate the database.
3. **Run the Queries**: Execute included SELECT queries and experiment with analytics tasks
4. **Explore and Modify**: Feel free to modify the queries to explore different aspects of the dataset or answer additional business questions.

## Author - nykjainprojects

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!


