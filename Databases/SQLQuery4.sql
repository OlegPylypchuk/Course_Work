USE CW_Database; -- Твоя стара база-джерело
GO

-- міняємо місцями дати, якщо Початок > Кінець
UPDATE EmployeePositionHistory
SET StartDate = EndDate, 
    EndDate = StartDate
WHERE StartDate > EndDate;