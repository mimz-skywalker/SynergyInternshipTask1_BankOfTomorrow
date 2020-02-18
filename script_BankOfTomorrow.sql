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






