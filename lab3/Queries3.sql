SELECT DISTINCT c.CustomerID, c.Name AS CustomerName
FROM Customers c
         JOIN Contracts ct ON c.CustomerID = ct.CustomerID
         JOIN Orders o ON ct.ContractID = o.ContractID
         JOIN OrderItems oi ON o.OrderID = oi.OrderID
         JOIN Products p ON oi.ProductID = p.ProductID
WHERE p.Manufacturer = 'Sony'
  AND oi.Quantity > 2
  AND oi.PriceAtOrder > 200
  AND o.OrderDate BETWEEN DATE_TRUNC('year', CURRENT_DATE) - INTERVAL '1 year'
    AND DATE_TRUNC('year', CURRENT_DATE) - INTERVAL '1 day';

SELECT DISTINCT c.Name AS CustomerName, ct.ContractID
FROM Customers c
         JOIN Contracts ct ON c.CustomerID = ct.CustomerID
         JOIN Orders o ON ct.ContractID = o.ContractID
WHERE (EXTRACT(MONTH FROM o.OrderDate) = 1 OR EXTRACT(MONTH FROM o.OrderDate) = 3)
  AND EXTRACT(YEAR FROM o.OrderDate) = EXTRACT(YEAR FROM CURRENT_DATE);