-- Скільки замовили одиниць кожного товару
SELECT p.ProductID,
       p.Name,
       p.Price,
       (SELECT COUNT(*) FROM OrderItems oi WHERE oi.ProductID = p.ProductID) AS OrderCount
FROM Products p;

-- Кількість замовлень, зроблених кожним клієнтом
SELECT c.CustomerID,
       c.Name,
       (SELECT COUNT(*)
        FROM Orders o
        WHERE o.ContractID IN
              (SELECT ContractID FROM Contracts WHERE CustomerID = c.CustomerID)) AS OrderCount
FROM Customers c;

-- Загальна вартість кожного замовлення з урахуванням вартості та кількості товарів
SELECT o.OrderID, SUM(oi.Quantity * oi.PriceAtOrder) AS TotalOrderValue
FROM Orders o,
     (SELECT OrderID, Quantity, PriceAtOrder FROM OrderItems) oi
WHERE o.OrderID = oi.OrderID
GROUP BY o.OrderID
ORDER BY o.OrderId;

-- Отримати замовлення та замовників, що містять товари з ціною понад 200
SELECT o.OrderID, o.OrderDate, c.Name
FROM Orders o
         JOIN Contracts ct ON o.ContractID = ct.ContractID
         JOIN Customers c ON ct.CustomerID = c.CustomerID
WHERE EXISTS (SELECT 1
              FROM OrderItems oi
                       JOIN Products p ON oi.ProductID = p.ProductID
              WHERE oi.OrderID = o.OrderID
                AND p.Price > 200);

-- Отримати клієнтів, у яких контракт закінчується пізніше 2025 року
SELECT Name
FROM Customers
WHERE CustomerID IN
      (SELECT CustomerID FROM Contracts WHERE EndDate > '2025-01-01');

-- Отримати комбінації всіх клієнтів та продуктів
SELECT c.Name AS CustomerName, p.Name AS ProductName
FROM Customers c,
     Products p;

-- Вибрати замовлення з продуктами та їхніми цінами
SELECT o.OrderID, o.OrderDate, p.Name AS ProductName, oi.PriceAtOrder
FROM Orders o
         JOIN OrderItems oi ON o.OrderID = oi.OrderID
         JOIN Products p ON oi.ProductID = p.ProductID
WHERE oi.PriceAtOrder > 500;

-- Отримати замовлення з інформацією про продукти, кількість та ціну під час замовлення
SELECT o.OrderID, p.Name AS ProductName, oi.Quantity, oi.PriceAtOrder
FROM Orders o
         INNER JOIN OrderItems oi ON o.OrderID = oi.OrderID
         INNER JOIN Products p ON oi.ProductID = p.ProductID;

-- Отримати всі продукти та відповідні опції доставки, якщо такі є
SELECT p.Name AS ProductName, d.DeliveryType, d.DeliveryPrice
FROM Products p
         LEFT JOIN DeliveryOptions d ON p.ProductID = d.ProductID;

-- Отримати всі опції доставки та продукти, для яких вони доступні
SELECT d.DeliveryType, p.Name AS ProductName
FROM DeliveryOptions d
         RIGHT JOIN Products p ON d.ProductID = p.ProductID;

-- Унікальні дати замовлень та початку контрактів
SELECT OrderDate AS EntityDate FROM orders
UNION
SELECT StartDate AS EntityDate FROM Contracts;

-- Дати, які є одночасно датами замовлень та початку контрактів
SELECT OrderDate AS EntityDate FROM orders
INTERSECT
SELECT StartDate AS EntityDate FROM Contracts;