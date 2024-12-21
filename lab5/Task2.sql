-- a. створити функцію, котра повертає деяке скалярне значення;
CREATE OR REPLACE FUNCTION GetOrderStatusCounts()
    RETURNS TABLE(DeliveredCount INT, PendingCount INT) AS $$
BEGIN
    RETURN QUERY
        SELECT
            CAST(COUNT(CASE WHEN od.Status = 'Delivered' THEN 1 END) AS INT) AS DeliveredCount,
            CAST(COUNT(CASE WHEN od.Status = 'Pending' THEN 1 END) AS INT) AS PendingCount
        FROM OrderDelivery od;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM GetOrderStatusCounts();
DROP FUNCTION IF EXISTS GetOrderStatusCounts();

-- b. створити функцію, котра повертає таблицю з динамічним набором стовпців;
CREATE OR REPLACE FUNCTION GetDynamicOrdersByCustomer(CustomerID INT, Columns TEXT)
    RETURNS TABLE(DynamicResult JSON) AS $$
BEGIN
    RETURN QUERY EXECUTE format(
            'SELECT json_agg(row_to_json(t)) FROM (SELECT %s FROM Orders o
             JOIN Contracts c ON o.ContractID = c.ContractID
             WHERE c.CustomerID = %s) t', Columns, CustomerID
                         );
END;
$$ LANGUAGE plpgsql;

SELECT * FROM GetDynamicOrdersByCustomer(3, 'OrderID, OrderDate, TotalAmount');
DROP FUNCTION IF EXISTS GetDynamicOrdersByCustomer(INT, TEXT);

-- c. створити функцію, котра повертає таблицю наперед заданої структури.
CREATE OR REPLACE FUNCTION GetProductsSummary()
    RETURNS TABLE(ProductID INT, Name VARCHAR(50), TotalQuantity INT, TotalRevenue DOUBLE PRECISION)
    LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
        SELECT p.ProductID,
               p.Name,
               CAST(SUM(oi.Quantity) AS INT) AS TotalQuantity,
               CAST(SUM(oi.Quantity * oi.PriceAtOrder) AS DOUBLE PRECISION) AS TotalRevenue
        FROM Products p
                 JOIN OrderItems oi ON p.ProductID = oi.ProductID
        GROUP BY p.ProductID, p.Name;
END;
$$;

SELECT * FROM GetProductsSummary();

DROP FUNCTION IF EXISTS GetProductsSummary();