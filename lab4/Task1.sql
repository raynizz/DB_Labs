-- a) запит з використанням функції COUNT (скільки замовили одиниць кожного товару)
SELECT p.ProductID,
       p.Name,
       p.Price,
       (SELECT COUNT(*) FROM OrderItems oi WHERE oi.ProductID = p.ProductID) AS OrderCount
FROM Products p;

-- b) запит з використанням функції SUM (загальна вартість кожного замовлення з урахуванням вартості та кількості товарів)
SELECT o.OrderID, SUM(oi.Quantity * oi.PriceAtOrder) AS TotalOrderValue
FROM Orders o,
     (SELECT OrderID, Quantity, PriceAtOrder FROM OrderItems) oi
WHERE o.OrderID = oi.OrderID
GROUP BY o.OrderID;

-- c) запит з використанням групування по декількох стовпцях;
SELECT o.OrderID, o.OrderDate, p.Name AS ProductName, oi.PriceAtOrder, od.Status
FROM Orders o,
     (SELECT OrderID, PriceAtOrder, ProductID FROM OrderItems) oi,
     (SELECT ProductID, Name FROM Products) p,
     (SELECT OrderID, Status FROM OrderDelivery) od
WHERE o.OrderID = oi.OrderID
  AND oi.ProductID = p.ProductID
  AND o.OrderID = od.OrderID
ORDER BY o.OrderID, oi.ProductID;

-- d) запит з використанням умови відбору груп HAVING;
SELECT c.CustomerID, c.Name AS CustomerName, o.OrderDate, o.TotalAmount, o.DeliveryCost
FROM Customers c
            JOIN Contracts ct ON c.customerID = ct.CustomerID
            JOIN Orders o ON ct.ContractID = o.ContractID
GROUP BY c.CustomerID, c.Name, o.OrderDate, o.TotalAmount, o.DeliveryCost
HAVING SUM(o.TotalAmount + o.DeliveryCost) > 900;

-- e) запит з використанням HAVING без GROUP BY;
SELECT COUNT(*) AS TotalCusntomers
FROM Customers
HAVING COUNT(*) > 10;

-- f) запит з використанням функцій row_number() over
SELECT p.ProductID, p.Name, p.Price, d.DeliveryType, d.DeliveryPrice,
       ROW_NUMBER() OVER (ORDER BY p.Price )
FROM Products p
         JOIN DeliveryOptions d ON p.ProductID = d.ProductID;

-- g) запит, в котрому значення одного зі стовпців таблиці будуть виведені в рядок через кому;
SELECT STRING_AGG(p.Name, ', ') AS ProductNames
FROM Products p
         JOIN OrderItems oi ON p.ProductID = oi.ProductID
WHERE Quantity > 3;

-- h) запит з використанням сортування по декількох стовпцях в різному порядку;
SELECT ct.ContractID, o.OrderDate, odl.ActualDeliveryDate, odl.Status, o.FinalAmount
FROM Contracts ct
         JOIN Orders o ON ct.ContractID = o.ContractID
         JOIN OrderDelivery odl ON o.OrderID = odl.OrderID
ORDER BY ct.ContractID, o.OrderDate DESC, odl.ActualDeliveryDate;

-- Визначить клієнта, з найбільшим обсягом закупівлі за минулий тиждень.
SELECT c.Name AS CustomerName, SUM(o.FinalAmount) AS FianlAmount
FROM Customers c
         JOIN Contracts ct ON c.CustomerID = ct.CustomerID
         JOIN Orders o ON ct.ContractID = o.ContractID
WHERE o.OrderDate BETWEEN CURRENT_DATE - INTERVAL '8 month' AND CURRENT_DATE
GROUP BY c.Name
ORDER BY FianlAmount DESC
LIMIT 1;

-- Визначить договори, по яких була найбільша кількість замовлень в різні місяці.
SELECT c.Name AS CustomerName, ct.ContractID, EXTRACT(MONTH FROM o.OrderDate) AS OrderMonth, COUNT(o.contractid) AS OrderCount
FROM Customers c
         JOIN Contracts ct ON c.CustomerID = ct.CustomerID
         JOIN Orders o ON ct.ContractID = o.ContractID
GROUP BY c.Name, ct.ContractID, OrderMonth
ORDER BY OrderCount DESC, OrderMonth;