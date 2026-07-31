/* ==========================================
   Data Validation
   ========================================== */
-- Preview the Dataset
SELECT TOP 10 *
FROM HR_Data;

--Total Number of Employees
SELECT COUNT(*) AS Total_Employees
FROM HR_Data;

-- Preview the Dataset
SELECT TOP 10 *
FROM HR_Data;

-- Check for Duplicate Employee Records
SELECT EmployeeNumber, COUNT(*) AS DuplicateCount
FROM HR_Data
GROUP BY EmployeeNumber
HAVING COUNT(*) > 1;

-- Check for Missing (NULL) Values
SELECT
    SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS Age_Nulls,
    SUM(CASE WHEN Attrition IS NULL THEN 1 ELSE 0 END) AS Attrition_Nulls,
    SUM(CASE WHEN Department IS NULL THEN 1 ELSE 0 END) AS Department_Nulls,
    SUM(CASE WHEN MonthlyIncome IS NULL THEN 1 ELSE 0 END) AS MonthlyIncome_Nulls
FROM HR_Data;

-- View Distinct Attrition Values
SELECT DISTINCT Attrition
FROM HR_Data;

-- Display Table Structure
EXEC sp_help 'HR_Data';

/* ==========================================
   Exploratory Data Analysis (EDA)
   ========================================== */
-- Employee Attrition Distribution
SELECT Attrition, COUNT(*) AS Employee_Count
FROM HR_Data
GROUP BY Attrition;


-- Department-wise Employee Count
SELECT Department,
       COUNT(*) AS Employee_Count
FROM HR_Data
GROUP BY Department
ORDER BY Employee_Count DESC;

--Gender Distribution
SELECT Gender,
       COUNT(*) AS Employee_Count
FROM HR_Data
GROUP BY Gender;

--Job Role Distribution
SELECT JobRole,
       COUNT(*) AS Employee_Count
FROM HR_Data
GROUP BY JobRole
ORDER BY Employee_Count DESC;

--Average Monthly Income by Department
SELECT Department,
       AVG(MonthlyIncome) AS Avg_Monthly_Income
FROM HR_Data
GROUP BY Department
ORDER BY Avg_Monthly_Income DESC;

--Attrition by Department
SELECT Department,
       Attrition,
       COUNT(*) AS Employee_Count
FROM HR_Data
GROUP BY Department, Attrition
ORDER BY Department;

--Average Age by Attrition
SELECT Attrition,
       AVG(Age) AS Average_Age
FROM HR_Data
GROUP BY Attrition;

--Attrition by Gender
SELECT Gender,
       Attrition,
       COUNT(*) AS Employee_Count
FROM HR_Data
GROUP BY Gender, Attrition;

--Average Years at Company by Attrition
SELECT Attrition,
       AVG(YearsAtCompany) AS Avg_Years
FROM HR_Data
GROUP BY Attrition;


/* ===========================================
   Advanced SQL Analysis
=========================================== */

--Overall Attrition Rate
SELECT
    COUNT(*) AS Total_Employees,
    SUM(CASE WHEN Attrition = 1  THEN 1 ELSE 0 END) AS Employees_Left,
    ROUND(
        SUM(CASE WHEN Attrition = 1  THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
        2
    ) AS Attrition_Rate_Percentage
FROM HR_Data;

SELECT DISTINCT Attrition
FROM HR_Data;

--Overtime vs Attrition
SELECT
    OverTime,
    Attrition,
    COUNT(*) AS Employee_Count
FROM HR_Data
GROUP BY OverTime, Attrition
ORDER BY OverTime;

-- Marital Status vs Attrition
SELECT
    MaritalStatus,
    Attrition,
    COUNT(*) AS Employee_Count
FROM HR_Data
GROUP BY MaritalStatus, Attrition
ORDER BY MaritalStatus;

-- Job Satisfaction vs Attrition
SELECT
    JobSatisfaction,
    Attrition,
    COUNT(*) AS Employee_Count
FROM HR_Data
GROUP BY JobSatisfaction, Attrition
ORDER BY JobSatisfaction;

-- Work-Life Balance vs Attrition
SELECT
    WorkLifeBalance,
    Attrition,
    COUNT(*) AS Employee_Count
FROM HR_Data
GROUP BY WorkLifeBalance, Attrition
ORDER BY WorkLifeBalance;

-- Average Monthly Income by Job Role
SELECT
    JobRole,
    AVG(MonthlyIncome) AS Avg_Monthly_Income
FROM HR_Data
GROUP BY JobRole
ORDER BY Avg_Monthly_Income DESC;

-- Top 10 Highest Paid Employees
SELECT TOP 10
    EmployeeNumber,
    JobRole,
    MonthlyIncome
FROM HR_Data
ORDER BY MonthlyIncome DESC;

-- Rank Employees by Monthly Income
SELECT
    EmployeeNumber,
    JobRole,
    MonthlyIncome,
    RANK() OVER (ORDER BY MonthlyIncome DESC) AS Income_Rank
FROM HR_Data;

-- Dense Rank Employees by Monthly Income
SELECT
    EmployeeNumber,
    JobRole,
    MonthlyIncome,
    DENSE_RANK() OVER (ORDER BY MonthlyIncome DESC) AS Dense_Income_Rank
FROM HR_Data;

-- Row Number by Monthly Income
SELECT
    EmployeeNumber,
    JobRole,
    MonthlyIncome,
    ROW_NUMBER() OVER (ORDER BY MonthlyIncome DESC) AS Row_Num
FROM HR_Data;

-- CTE: Average Monthly Income by Department
WITH DepartmentIncome AS
(
    SELECT
        Department,
        AVG(MonthlyIncome) AS Avg_Monthly_Income
    FROM HR_Data
    GROUP BY Department
)
SELECT *
FROM DepartmentIncome
ORDER BY Avg_Monthly_Income DESC;

-- Employees Earning Above Average Salary
WITH AvgSalary AS
(
    SELECT AVG(MonthlyIncome) AS Average_Salary
    FROM HR_Data
)
SELECT
    EmployeeNumber,
    JobRole,
    MonthlyIncome
FROM HR_Data
CROSS JOIN AvgSalary
WHERE MonthlyIncome > Average_Salary
ORDER BY MonthlyIncome DESC;

-- Create Employee Attrition View
CREATE VIEW Employee_Attrition_View AS
SELECT
    EmployeeNumber,
    Department,
    JobRole,
    Attrition,
    MonthlyIncome,
    YearsAtCompany
FROM HR_Data;

SELECT *
FROM Employee_Attrition_View;