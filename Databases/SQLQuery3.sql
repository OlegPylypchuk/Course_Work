USE CW_DW;
GO

-- 1. Створюємо порожню таблицю
CREATE TABLE DimDate (
    DateKey INT PRIMARY KEY,        -- 20250104
    FullDate DATE,                  -- 2025-01-04
    Year INT,                       -- 2025
    Month INT,                      -- 1
    MonthName NVARCHAR(20),         -- January
    Day INT,                        -- 4
    DayOfWeekName NVARCHAR(20),     -- Saturday
    Quarter INT                     -- 1
);
GO

-- 2. Заповнюємо датами (з 2010 по 2030 рік)
DECLARE @StartDate DATE = '2010-01-01';
DECLARE @EndDate DATE = '2030-12-31';

WHILE @StartDate <= @EndDate
BEGIN
    INSERT INTO DimDate (
        DateKey, FullDate, Year, Month, MonthName, Day, DayOfWeekName, Quarter
    )
    SELECT 
        CAST(CONVERT(VARCHAR(8), @StartDate, 112) AS INT),
        @StartDate,
        YEAR(@StartDate),
        MONTH(@StartDate),
        DATENAME(MONTH, @StartDate),
        DAY(@StartDate),
        DATENAME(WEEKDAY, @StartDate),
        DATEPART(QUARTER, @StartDate);

    SET @StartDate = DATEADD(dd, 1, @StartDate);
END
GO