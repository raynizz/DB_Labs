SELECT * FROM Products WHERE Price > 500;

SELECT * FROM Contracts WHERE EndDate > '2024-12-31';

SELECT * FROM Customers WHERE ContactInfo IS NOT NULL AND DeliveryAddress LIKE '%Omaha%';

SELECT * FROM Orders WHERE OrderDate BETWEEN '2024-01-01' AND '2024-12-31';

SELECT * FROM Orders WHERE TotalAmount > 1000 AND DeliveryCost >= 20;

SELECT * FROM Products WHERE HasDelivery = TRUE AND Manufacturer = 'Sony';

SELECT Name, Price,
       CASE WHEN Price > 1000 THEN Price * 0.9 ELSE Price END AS DiscountedPrice
FROM Products;

SELECT * FROM Products WHERE Manufacturer IN ('Apple', 'Samsung', 'Sony');

SELECT * FROM Orders WHERE TotalAmount BETWEEN 1000 AND 2000;

SELECT * FROM Customers WHERE DeliveryAddress LIKE '%FL';