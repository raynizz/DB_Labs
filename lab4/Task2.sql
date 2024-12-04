-- a) створити представлення з конкретним переліком атрибутів, котрі обираються, та котре містить дані з декількох таблиць;
CREATE VIEW Task1 AS
    SELECT o.OrderID,  p.Name AS ProductName, oi.PriceAtOrder, o.OrderDate, odl.Status
FROM Orders o
        JOIN OrderDelivery odl ON o.OrderID = odl.OrderID
        JOIN OrderItems oi ON o.OrderID = oi.OrderID
        JOIN Products p ON oi.ProductID = p.ProductID
WHERE odl.Status = 'Delivered'
ORDER BY o.OrderID, oi.ProductID;

SELECT * FROM Task1;

DROP VIEW Task1;

-- b) створити представлення, котре містить дані з декількох таблиць та використовує представлення, котре створене в п.a;
CREATE VIEW Task2 AS
    SElECT c.Name AS CustomerName, t.OrderID, t.ProductName, t.PriceAtOrder, t.OrderDate, t.Status
FROM Task1 t
        JOIN Orders o ON t.OrderID = o.OrderID
        JOIN Contracts ct ON o.ContractID = ct.ContractID
        JOIN Customers c ON ct.CustomerID = c.CustomerID
ORDER BY t.OrderID, c.Name;

SELECT * FROM Task2;

DROP VIEW Task2;

-- c) модифікувати представлення з використанням команди ALTER VIEW;
ALTER VIEW IF EXISTS Task2 RENAME TO CustomersOrders;

SELECT * FROM CustomersOrders;

DROP VIEW CustomersOrders;

