USE CW_Database; 
GO

-- 1. Створення таблиці Посад (Positions)
CREATE TABLE Positions (
    PositionID INT IDENTITY(1,1) NOT NULL,
    PositionName NVARCHAR(100) NOT NULL,
    BaseSalary DECIMAL(10, 2) NOT NULL CHECK (BaseSalary > 0),
    CONSTRAINT PK_Positions PRIMARY KEY CLUSTERED (PositionID)
);
GO

-- 2. Створення таблиці Відділів (Departments)
CREATE TABLE Departments (
    DepartmentID INT IDENTITY(1,1) NOT NULL,
    DepartmentName NVARCHAR(100) NOT NULL,
    ManagerID INT NULL, 
    CONSTRAINT PK_Departments PRIMARY KEY CLUSTERED (DepartmentID)
);
GO

-- 3. Створення таблиці Працівників (Employees)
CREATE TABLE Employees (
    EmployeeID INT IDENTITY(1,1) NOT NULL,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    DateOfBirth DATE NOT NULL,
    Gender CHAR(1) CHECK (Gender IN ('M', 'F')),
    ContactInfo NVARCHAR(200),
    HireDate DATE NOT NULL,
    CONSTRAINT PK_Employees PRIMARY KEY CLUSTERED (EmployeeID)
);
GO

-- 4. Створення таблиці Історії Посад (EmployeePositionHistory)
CREATE TABLE EmployeePositionHistory (
    HistoryID INT IDENTITY(1,1) NOT NULL,
    EmployeeID INT NOT NULL,
    DepartmentID INT NOT NULL,
    PositionID INT NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NULL, -- NULL означає, що це поточна посада
    
    CONSTRAINT PK_EmployeePositionHistory PRIMARY KEY CLUSTERED (HistoryID),
    
    CONSTRAINT FK_History_Employee FOREIGN KEY (EmployeeID) 
        REFERENCES Employees(EmployeeID) ON DELETE CASCADE,
    CONSTRAINT FK_History_Department FOREIGN KEY (DepartmentID) 
        REFERENCES Departments(DepartmentID),
    CONSTRAINT FK_History_Position FOREIGN KEY (PositionID) 
        REFERENCES Positions(PositionID),
        
    CONSTRAINT CK_History_Dates CHECK (EndDate IS NULL OR EndDate >= StartDate)
);
GO

-- 5. Створення таблиці Відпусток (Vacations)
CREATE TABLE Vacations (
    VacationID INT IDENTITY(1,1) NOT NULL,
    EmployeeID INT NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    VacationType NVARCHAR(50) NOT NULL CHECK (VacationType IN (N'Планова', N'Лікарняний', N'За свій рахунок')),
    
    CONSTRAINT PK_Vacations PRIMARY KEY CLUSTERED (VacationID),
    
    CONSTRAINT FK_Vacations_Employee FOREIGN KEY (EmployeeID) 
        REFERENCES Employees(EmployeeID) ON DELETE CASCADE,
        
    CONSTRAINT CK_Vacation_Dates CHECK (EndDate >= StartDate)
);
GO

-- Додавання зовнішнього ключа для Керівника відділу
ALTER TABLE Departments
ADD CONSTRAINT FK_Departments_Manager FOREIGN KEY (ManagerID) 
    REFERENCES Employees(EmployeeID);
GO


CREATE NONCLUSTERED INDEX IX_Employees_LastName ON Employees(LastName);
CREATE NONCLUSTERED INDEX IX_History_EmployeeID ON EmployeePositionHistory(EmployeeID);
CREATE NONCLUSTERED INDEX IX_History_DepartmentID ON EmployeePositionHistory(DepartmentID);
CREATE NONCLUSTERED INDEX IX_History_PositionID ON EmployeePositionHistory(PositionID);
CREATE NONCLUSTERED INDEX IX_History_EndDate ON EmployeePositionHistory(EndDate) WHERE EndDate IS NULL;
CREATE NONCLUSTERED INDEX IX_Vacations_StartDate ON Vacations(StartDate);
GO