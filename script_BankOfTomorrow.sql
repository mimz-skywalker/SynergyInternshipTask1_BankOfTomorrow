--CREATE DATABASE BankOfTomorrow


CREATE TABLE Employees
( Employee_ID NUMBER(15) NOT NULL,
  FirstName VARCHAR(255) NOT NULL,
  LastName VARCHAR(255) NOT NULL,
  JobTitle VARCHAR(255) NOT NULL,
  Fullname VARCHAR(255),
  Salary DECIMAL NOT NULL,
  Address VARCHAR(255) NOT NULL,
  Manager_ID NUMBER(15),
  Department_ID NUMBER(15),
  CONSTRAINT Employee_PK PRIMARY KEY(Employee_ID),
  CONSTRAINT Department_FK FOREIGN KEY(Department_ID) REFERENCES Departments(Department_ID)
        ON DELETE SET NULL,
  CONSTRAINT Manager_FK FOREIGN KEY(Manager_ID) REFERENCES Employees (Employee_id)
        ON DELETE SET NULL
);
 
 
CREATE TABLE Clients
( Client_ID NUMBER(15) NOT NULL,
  FirstName VARCHAR(255) NOT NULL,
  LastName VARCHAR(255) NOT NULL,
  LastLog DATE NOT NULL,
  Client_Password VARCHAR(15) NOT NULL,
  CONSTRAINT Clients_PK PRIMARY KEY(Client_ID)
);

CREATE TABLE Departments
( Department_ID NUMBER(15) NOT NULL,
  DepartmentName VARCHAR(255) NOT NULL,
  Town_ID NUMBER(15) NOT NULL,
  CONSTRAINT Department_PK PRIMARY KEY(Department_ID),
  CONSTRAINT Town_FK FOREIGN KEY(Town_ID) REFERENCES Towns(Town_ID)
        ON DELETE SET NULL

);

CREATE TABLE Towns
(
  Town_ID NUMBER(15) NOT NULL,
  TownName VARCHAR(255) NOT NULL,
  CONSTRAINT Town_PK PRIMARY KEY(Town_ID)
);





--?	Find information about all departments names:
SELECT DepartmentName 
FROM Departments; 

--?	Find the salary of each employee
SELECT FirstName, LastName, Salary 
FROM Employees;

--?	Find the full name of each employee
SELECT FirstName, LastName
FROM Employees;

--?	Create a query that produces an employ email address by using the employee first and last name. 
--The user E-mail consists of first name and last name concatenated by a full stop. 
--The domain of the E-mail is fakecompany.com. 
--The result must be produced in a separate column named Full name
SELECT CONCAT(CONCAT(CONCAT(FirstName, '.'), LastName), '@fakecompany.com') AS FullName
FROM Employees;

--?	Find all employ with job title Senior executive
SELECT * 
FROM Employees
WHERE JobTitle = 'Senior executive'
ORDER BY Employee_ID;

--?	Find all employs with name starts with letter S
SELECT *
FROM Employees
WHERE FirstName LIKE 'S%'
ORDER BY Employee_ID;

--?	Find all employees with a name that contains the letter l
SELECT FirstName, LastName
FROM Employees
WHERE CONCAT(FirstName, LastName) LIKE '%l%'
ORDER BY Employee_ID;

--?	Find all employees that have a salary in the range 2000 – 3000
SELECT FirstName, LastName, Salary
FROM Employees
WHERE Salary BETWEEN 2000 AND 3000
ORDER BY Employee_ID;

--?	Find all employees that have salaries 2500 / 3000 / 3500 / 5000
SELECT FirstName, LastName, Salary
FROM Employees
WHERE (Salary = 2500) OR (Salary = 3000) OR (Salary = 3500) OR (Salary = 5000) 
ORDER BY Employee_ID;

--?	Find all employees that do not have a manager
SELECT FirstName, LastName, Manager_ID
FROM Employees
WHERE Manager_ID IS NULL
ORDER BY Employee_ID;

--?	Find all employees that have a senior position in the company and have a salary greater than 5000. 
--Order them in decreasing order and by alphabetical order by there first name
SELECT * 
FROM Employees
WHERE JobTitle LIKE '%Senior%' AND (Salary>5000)
ORDER BY FirstName DESC;

--?	Find the top 5 best-paid employees
SELECT * 
FROM Employees
WHERE ROWNUM <= 5
ORDER BY Salary DESC;

--?	Find all employees and their addresses
SELECT FirstName, LastName, Address
FROM Employees;


--?	Find all employees and their manager
--Self Join
SELECT A.FirstName AS EmployeeFN, A.LastName AS EmployeeLN, B.FirstName AS ManagerFN, B.LastName AS ManagerLN
FROM Employees A, Employees B
WHERE A.Manager_ID = B.Employee_ID
ORDER BY A.Employee_ID;

--?	Find all employees along with their manager and address
SELECT A.FirstName AS EmployeeFN, A.LastName AS EmployeeLN, A.Address AS EmployeeAddress, B.FirstName AS ManagerFN, B.LastName AS ManagerLN, B.Address AS ManagerAddress
FROM Employees A, Employees B
WHERE A.Manager_ID = B.Employee_ID
ORDER BY A.Employee_ID;

--?	Find all departments and all town names as a single list
--Full Join
SELECT D.DepartmentName AS Department, T.TownName AS Town
FROM Departments D
FULL JOIN Towns T
ON D.Town_ID = T.Town_ID
ORDER BY D.Town_ID;

--?	Find all of the employees and the manager for each of them along with the employees that do not have a manager
--LEFT JOIN
SELECT A.FirstName AS EmployeeFN, A.LastName AS EmployeeLN, B.FirstName AS ManagerFN, B.LastName AS ManagerLN
FROM Employees A
LEFT JOIN Employees B
ON A.Manager_ID = B.Employee_ID
ORDER BY A.Employee_ID;

--?	Find all employees from “Sales” and all from “Finance” who are hired between 1995 and 2005
SELECT E.FirstName, E.LastName, E.Hire_Date, D.DepartmentName
FROM Employees E
FULL JOIN Departments D
ON E.Department_ID = D.Department_ID
WHERE ((D.DepartmentName = 'Finance') OR (D.DepartmentName = 'Sales')) AND (EXTRACT(YEAR FROM E.Hire_Date) BETWEEN 1995 AND 2005 )
ORDER BY E.Employee_ID;

--?	Find the full name and salary of the employee that takes minimal salary in the company.
SELECT FirstName, LastName, MIN(Salary) AS MinSalary
FROM Employees 
WHERE ROWNUM = 1
GROUP BY FirstName, LastName;

--?	Find the names and the salary of the employees that have a salary that is up to 10% higher than the minimum salary for the company
SELECT FirstName, LastName, Salary
FROM Employees
WHERE Salary > (SELECT MIN(Salary) FROM Employees) AND  Salary <=((SELECT MIN(Salary) FROM Employees) + (SELECT MIN(Salary) FROM Employees)*0.1);

--?	Find the full name salary and the department of the employees that take the minimum salary in their department.
--UNFINISHED
SELECT D.Department_ID, D.DepartmentName, MIN(Salary) AS MinSalary 
FROM ( SELECT E.FirstName, E.LastName, D.Department_ID, D.DepartmentName, MIN(Salary) AS MinSalary
       FROM Employees E
       FULL JOIN Departments D
       ON E.Department_ID = D.Department_ID;) AS D
JOIN Departments D
ON ENames.Department_ID = D.Department_ID
GROUP BY D.Department_ID, D.DepartmentName
ORDER BY D.Department_ID;

                
                
--?	Find the average salary in all department list the department name and the average salary
SELECT D.Department_ID, D.DepartmentName, AVG(Salary) AS AverageSalary 
FROM Employees E
FULL JOIN Departments D
ON E.Department_ID = D.Department_ID
GROUP BY D.Department_ID, D.DepartmentName
ORDER BY D.Department_ID;


--?	Find the number of employee in all the departments. List the department and the number of employees in it
SELECT D.Department_ID, D.DepartmentName, COUNT(E. Employee_ID) AS NumberOfEmployee
FROM Employees E
FULL JOIN Departments D
ON E.Department_ID = D.Department_ID
GROUP BY D.Department_ID, D.DepartmentName
ORDER BY D.Department_ID;


--?	Group all employee by the manager
--UNFINISHED
SELECT A.FirstName AS EmployeeFN, A.LastName AS EmployeeLN, B.FirstName AS ManagerFN, B.LastName AS ManagerLN
FROM Employees A
JOIN (SELECT )
ON A.Manager_ID = B.Employee_ID
GROUP BY B.FirstName, B.LastName;


--?	Find all employees whose names are exactly 5 characters
SELECT FirstName, LastName
FROM Employees
WHERE LENGTH(FirstName) = 5

--?	Create a view that shows all clients that have been in the system today
CREATE VIEW LogToday AS
    SELECT C.FirstName, C.LastName, C.LastLog
    FROM Clients C
    WHERE C.LastLog = CURRENT_DATE;
    
--?	Change the passwords of all clients that are absent from the system since 10.03.2010
UPDATE Clients
SET Client_Password = 'newpass123'
WHERE Clients.LastLog <= TO_DATE('10-MAR-2010', 'DD-MON-YYYY')

--?	Delete all clients without password
DELETE FROM Clients
WHERE Client_Password IS NULL

--?	Display the town with max employees 
SELECT T.TownName, COUNT(Employee_ID) AS EmployeeCount
FROM Towns T
FULL JOIN Departments D
ON T.Town_ID = D.Town_ID 
FULL JOIN Employees E
ON E.Department_ID = D.Department_ID
GROUP BY T.TownName
ORDER BY EmployeeCount DESC;

--Create a transaction that deletes the information from the tables, drop all the tables and reroll the transaction at the end of the process
BEGIN
 DELETE FROM Clients;
 DELETE FROM Departmnets;
 DELETE FROM Employees;
 DELETE FROM Towns;
 
 DROP TABLE Clients;
 DROP TABLE Departments;
 DROP TABLE Employees;
 DROP TABLE Towns;
 
 ROLLBACK;
END











