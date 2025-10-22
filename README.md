<img width="65" height="21" alt="image" src="https://github.com/user-attachments/assets/746208c9-682d-41f4-a22e-ce96662f642a" /># Employee and HR Analytics SQL Project

## Project Overview

**Project Title**: Employee and HR Analytics 
**Level**: Beginner  
**Database**: `EMP_HR_ANALYTICS`

This SQL project provides a complete Employee and HR analytics database, including tables for Employee, Department, Performance, and Attendance. The project enables advanced HR reporting and analytics with more than 15 practical query examples. It is designed for portfolio development and learning advanced SQL concepts, including JOINs, aggregate queries, ranking, window functions, and analytical tasks.

## Objectives

1. **Set up a database**: Build a database to store employee details, departments, salaries, attendance, and performance metrics.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Data Analysis**: Write queries to analyze headcount trends, salary distribution, employee turnover, and department-wise performance.

## Project Structure

### 1. Database Structure

**Department**: Stores department details (DeptID, DeptName, Location)

**Employee**: Stores employee information (EmpID, FirstName, LastName, JobTitle, ManagerID, HireDate, Salary, DeptID)

**Performance**: Stores performance reviews (PerfID, EmpID, ReviewDate, Rating, Comments)

**Attendance**: Tracks daily attendance status (AttID, EmpID, AttDate, Status)

```sql 
Create database EMP_HR_ANALYTICS;

CREATE TABLE Department (
  DeptID INT PRIMARY KEY,
  DeptName VARCHAR(50),
  Location VARCHAR(50)
);

CREATE TABLE Employee (
  EmpID INT PRIMARY KEY,
  FirstName VARCHAR(50),
  LastName VARCHAR(50),
  JobTitle VARCHAR(50),
  ManagerID INT NULL,
  HireDate DATE,
  Salary DECIMAL(10,2),
  DeptID INT,
  FOREIGN KEY (DeptID) REFERENCES Department(DeptID),
  FOREIGN KEY (ManagerID) REFERENCES Employee(EmpID)
);

CREATE TABLE Performance (
  PerfID INT PRIMARY KEY,
  EmpID INT,
  ReviewDate DATE,
  Rating INT,
  Comments VARCHAR(255),
  FOREIGN KEY (EmpID) REFERENCES Employee(EmpID)
);

CREATE TABLE 	 (
  AttID INT PRIMARY KEY,
  EmpID INT,
  AttDate DATE,
  Status VARCHAR(20),  -- e.g. Present, Absent, Leave
  FOREIGN KEY (EmpID) REFERENCES Employee(EmpID)
);
```

### 2. Data Exploration & Cleaning

- **Employee Count**: Determine the total number of employee in the dataset.
- **Manager Count**: Determine the total number of Manager in the dataset.
- **Department Count**: Identify all unique Departments in the dataset.
  ```

### 3. Data Analysis & Findings

The following SQL queries were developed to analyze Employee performance:

1. **List all employees with their department names**:
```sql
SELECT e.EmpID, e.FirstName, e.LastName, d.DeptName
FROM Employee e
JOIN Department d ON e.DeptID = d.DeptID;;
```

2. **Get average salary by department**:
```sql
SELECT d.DeptName, AVG(e.Salary) AS AvgSalary
FROM Employee e
JOIN Department d ON e.DeptID = d.DeptID
GROUP BY d.DeptName;
```

3. **Find employees with performance rating above 4**:
```sql
SELECT e.FirstName, e.LastName, p.Rating, p.Comments
FROM Performance p
JOIN Employee e ON p.EmpID = e.EmpID
WHERE p.Rating > 4
```

4. **Count attendance status for each employee in September 2025**:
```SELECT e.FirstName, e.LastName, a.Status, COUNT(*) AS Days
FROM Attendance a
JOIN Employee e ON a.EmpID = e.EmpID
WHERE a.AttDate BETWEEN '2025-09-01' AND '2025-09-30'
GROUP BY e.FirstName, e.LastName, a.Status;
```

5. **Find employees who earn more than their manager**:
```sql
SELECT e.EmpID, e.FirstName, e.LastName, e.Salary, m.FirstName AS ManagerFirstName, m.LastName AS ManagerLastName, m.Salary AS ManagerSalary
FROM Employee e
JOIN Employee m ON e.ManagerID = m.EmpID
WHERE e.Salary > m.Salary;
```

6. **Calculate year-over-year salary growth for each employee**:
```sql
WITH SalaryByYear AS (
  SELECT EmpID, EXTRACT(YEAR FROM HireDate) AS Year, Salary
  FROM Employee
),
SalaryGrowth AS (
  SELECT 
    s1.EmpID, s1.Year AS Year,
    s1.Salary AS CurrentSalary,
    s2.Salary AS PreviousSalary,
    ROUND(((s1.Salary - s2.Salary) / NULLIF(s2.Salary, 0)) * 100, 2) AS SalaryGrowthPercent
  FROM SalaryByYear s1
  LEFT JOIN SalaryByYear s2 ON s1.EmpID = s2.EmpID AND s1.Year = s2.Year + 1
)
SELECT * FROM SalaryGrowth
WHERE SalaryGrowthPercent IS NOT NULL;
```

7. **Rank employees within their departments by salary**:
```sql
SELECT 
  EmpID, FirstName, LastName, DeptID, Salary,
  RANK() OVER (PARTITION BY DeptID ORDER BY Salary DESC) AS SalaryRank
FROM Employee;
```

8. **Calculate the percentage of employees meeting or exceeding a rating threshold by department**:
```sql
WITH RatedEmployees AS (
  SELECT e.DeptID, p.EmpID, p.Rating
  FROM Employee e
  JOIN Performance p ON e.EmpID = p.EmpID
),
RatingsSummary AS (
  SELECT DeptID,
    COUNT(*) AS TotalEmployees,
    SUM(CASE WHEN Rating >= 4 THEN 1 ELSE 0 END) AS EmployeesMeetingThreshold
  FROM RatedEmployees
  GROUP BY DeptID
)
SELECT d.DeptName, 
       TotalEmployees,
       EmployeesMeetingThreshold,
       ROUND((EmployeesMeetingThreshold * 100.0) / TotalEmployees, 2) AS PercentMeetingThreshold
FROM RatingsSummary rs
JOIN Department d ON rs.DeptID = d.DeptID;
```

9. **Identify employees with perfect attendance in a given month**:
```sql
WITH MonthlyAttendance AS (
  SELECT EmpID, COUNT(*) AS DaysPresent
  FROM Attendance
  WHERE AttDate BETWEEN '2025-09-01' AND '2025-09-30' AND Status = 'Present'
  GROUP BY EmpID
),
WorkingDays AS (
  SELECT COUNT(*) AS TotalWorkingDays
  FROM Attendance
  WHERE AttDate BETWEEN '2025-09-01' AND '2025-09-30'
  GROUP BY AttDate
)
SELECT e.EmpID, e.FirstName, e.LastName
FROM Employee e
JOIN MonthlyAttendance ma ON e.EmpID = ma.EmpID
CROSS JOIN WorkingDays wd
WHERE ma.DaysPresent = wd.TotalWorkingDays;
```

10. **Employees with performance rating 4 or above and their comments**:
```sql
SELECT e.EmpID, e.FirstName, e.LastName, p.Rating, p.Comments
FROM Employee e
JOIN Performance p ON e.EmpID = p.EmpID
WHERE p.Rating >= 4;
```
11. **Count of employees by attendance status on a specific date**:
```sql
Select Status, Count(*) as EmpCount
From Attendance
Where Attdate='2025-09-01'
Group by Status;
```
12. **Average salary of employees with performance rating 5**:
```sql
Select Round(Avg(E.Salary),2) As AvgSalaryHighPerformers
From Employee E
Join performance P on P.empID= E.EmpID
Where P.Rating=5;
```
13. **Employees on leave and their departments**:
```sql
Select E.FirstName, E.LastName, D.DeptName
From employee E
Join department D on D.DeptID=E.DeptID
Join attendance A on A.EmpID=E.EmpID
Where A.Attdate = '2025-09-01' and A.Status='Leave';
```
14. **Performance summary: average rating by department**:
```sql
Select D.Deptname, Avg(P.Rating) AS AvgDeptRating
From Department D
Join Employee E on E.deptID=D.deptid
Join performance P on P.EmpID=E.empID
group by D.DeptName;
```
15. **Employees rated 3 or less with their attendance status**:
```sql
Select E.firstName, E.lastName, Status
From employee E
Join attendance A on A.EmpID=E.EmpID
Join performance P on P.EmpID=E.EmpID
Where P.rating<=3 and Attdate='2025-09-01';
```
16. **List employees not present on 2025-09-01 along with their manager names**:
```sql
Select E.EmpID, E.FirstName as EmpFirstName, E.lastName as EmpLastName, M.firstname as ManFirstName, M.lastName as ManLastName
From Employee E
Left Join employee M on E.ManagerID=M.EmpID
Join attendance A on A.EmpID=E.empid
Where  A.AttDate='2025-09-01' and A.Status <> 'Present' ;
```
17. **Employees hired after 2018 with their performance ratings**:
```sql
Select E.FirstName,E.lastName, P.Rating
From employee E
Join performance P on E.EmpID=P.EmpID
Where E.HireDate>'2018-01-01';
```
18. **Number of employees reporting to each manager**:
```sql
Select M.FirstName, M.LastName, Count(E.empID) as EmpCount
From employee E
Join employee M on M.EmpID=E.ManagerID
group By M.FirstName,M.LastName
Order By Count(E.empID) Desc;
```
19. **Attendance percentage (Present days) for each employee in September 2025**:
```sql
With TotalDays AS(
	Select Count(distinct Attdate) AS WorkingDays
    From attendance
    Where AttDate Between '2025-09-01' and '2025-09-30'
    ),
PresentDays AS (
	Select EmpID, Count(*) as DaysPresent
    From attendance
    Where Status = 'Present' and AttDate Between '2025-09-01' and '2025-09-30'
    Group by EmpID
)
Select E.FirstName, E.LastName,
		Round((PD.DaysPresent / TD.WorkingDays) * 100,2) as AttendancePercent
From Employee E
Left Join PresentDays PD on PD.empID=E.EmpID
Cross Join TotalDays TD
Order By AttendancePercent Desc;
```


## Findings

- The dataset includes comprehensive employee, department, performance, and attendance information for an HR analytics environment, with over 15 employees and records for multiple HR functions.
- Average salary by department reveals higher compensation in managerial, research, and marketing roles, with entry-level and support departments earning less.
- Around 30% of employees regularly achieve high performance ratings (4 and above), showing strong overall productivity, while only a few employees consistently receive ratings below 3.

## Reports

- **Department Salary Summary**: Managers and product/marketing professionals have the highest average salaries, as shown by joining Employee and Department tables and aggregating by DeptName.
- **Performance Review Summary**: Employees with performance ratings above 4 are found across research, IT, and marketing, indicating these departments foster excellence. Detailed comments on strengths are recorded in the Performance table.
- **Attendance Analysis**: Most employees maintain above 80% attendance in September 2025. Only a few employees (identified by monthly queries) had perfect attendance, while others had some absences or leaves. Attendance breakdowns by status (Present, Absent, Leave) are available by combining Employee and Attendance tables.

## Conclusion

The Employee And HR Analytics SQL project demonstrates effective HR data management and provides meaningful analytics through complex queries. The database structure supports granular reporting on salaries, performance, and attendance, and the sample data highlights strong departmental performance with targeted areas for improvement. The project serves as a robust portfolio example for advanced SQL capabilities in HR analytics contexts.

## How to Use

1. **Clone the Repository**: Clone this project repository from GitHub.
2. **Set Up the Database**: Run the SQL scripts provided in the `Employee And HR Analytics.sql` file to create and populate the database.
3. **Run the Queries**: Execute included SELECT queries and experiment with analytics tasks
4. **Explore and Modify**: Feel free to modify the queries to explore different aspects of the dataset or answer additional business questions.

## Author - nykjainprojects

This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!


