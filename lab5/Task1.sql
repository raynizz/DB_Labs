-- а. створення процедури, в якій використовується тимчасова таблиця, котра створена через змінну типу TABLE;
CREATE OR REPLACE PROCEDURE UseTempTableExample()
    LANGUAGE plpgsql AS
$$
BEGIN
    DROP TABLE IF EXISTS TempTable;
    CREATE TEMP TABLE TempTable
    (
        ProductID     INT,
        Name          VARCHAR,
        TotalQuantity INT
    );

    INSERT INTO TempTable
    SELECT p.ProductID, p.Name, SUM(oi.Quantity)
    FROM Products p
             JOIN OrderItems oi ON p.ProductID = oi.ProductID
    GROUP BY p.ProductID, p.Name;

    RAISE NOTICE 'Результати в тимчасовій таблиці створені';
END;
$$;

CALL UseTempTableExample();
SELECT *
FROM TempTable;
DROP PROCEDURE UseTempTableExample;

-- b. створення процедури з використанням умовної конструкції IF;
CREATE OR REPLACE PROCEDURE CheckQuantityOrders(IdProduct INT)
    LANGUAGE plpgsql AS
$$
DECLARE
    Stock INT;
BEGIN
    SELECT COALESCE(SUM(Quantity), 0)
    INTO Stock
    FROM OrderItems oi
    WHERE ProductId = IdProduct;

    IF Stock > 0 THEN
        RAISE NOTICE 'Продукт замовлений. Замовлень: %', Stock;
    ELSE
        RAISE NOTICE 'Продукт не замовляли.';
    END IF;
END;
$$;

CALL CheckQuantityOrders(20);
DROP PROCEDURE CheckQuantityOrders;

-- c. створення процедури з використанням циклу WHILE;
CREATE OR REPLACE PROCEDURE ListProducts()
    LANGUAGE plpgsql AS
$$
DECLARE
    counter        INT := 1;
    total_products INT;
    product_name   VARCHAR(255);
    product_price  FLOAT;
BEGIN
    SELECT COUNT(*) INTO total_products FROM Products;

    WHILE counter <= total_products
        LOOP
            SELECT Name, Price
            INTO product_name, product_price
            FROM Products
            WHERE ProductID = counter;

            RAISE NOTICE 'Product: %, Price: %', product_name, product_price;
            counter := counter + 1;
        END LOOP;
END;
$$;

CALL ListProducts();
DROP PROCEDURE ListProducts;

-- d. створення процедури без параметрів;
CREATE OR REPLACE PROCEDURE ListCustomers()
    LANGUAGE plpgsql AS
$$
DECLARE
    customer_record RECORD;
BEGIN
    FOR customer_record IN
        SELECT Name, ContactInfo FROM Customers
        LOOP
            RAISE NOTICE 'Customer: %, Contact Info: %', customer_record.Name, customer_record.ContactInfo;
        END LOOP;
END;
$$;

CALL ListCustomers();
DROP PROCEDURE ListCustomers;

-- e. створення процедури з вхідним параметром та RETURN;
CREATE OR REPLACE PROCEDURE GetTotalAmountForCustomer(customer_id INT, OUT total_amount FLOAT)
    LANGUAGE plpgsql AS
$$
BEGIN
    SELECT COALESCE(SUM(o.finalamount), 0)
    INTO total_amount
    FROM Orders o
             JOIN Contracts ct ON o.ContractID = ct.ContractID
    WHERE ct.CustomerID = customer_id;
END;
$$;

CALL GetTotalAmountForCustomer(10, 0);
DROP PROCEDURE GetTotalAmountForCustomer;

-- f. створення процедури оновлення даних в деякій таблиці БД;
CREATE OR REPLACE PROCEDURE UpdateProductPrice(product_id INT, new_price FLOAT)
    LANGUAGE plpgsql AS
$$
BEGIN
    UPDATE Products
    SET Price = new_price
    WHERE ProductID = product_id;
END;
$$;

SELECT *
FROM Products
WHERE ProductID = 1;
CALL UpdateProductPrice(1, 1199.99);
DROP PROCEDURE UpdateProductPrice;

-- g. створення процедури, в котрій робиться вибірка даних.
CREATE OR REPLACE PROCEDURE GetCustomersByCity(location VARCHAR)
    LANGUAGE plpgsql AS
$$
DECLARE
    record RECORD;
BEGIN
    RAISE NOTICE 'Customers which ordered from %:', location;
    FOR record IN
        SELECT c.CustomerID AS customer_id,
               c.Name AS customer_name,
               c.ContactInfo AS customers_contact_info,
               c.DeliveryAddress AS customers_delivery_address
        FROM Customers c
        WHERE c.DeliveryAddress LIKE '%' || location || '%'
        LOOP
            RAISE NOTICE 'Customer ID: %, Name: %, Contact Info: %, Delivery Address: %',
                record.customer_id, record.customer_name, record.customers_contact_info, record.customers_delivery_address;
        END LOOP;
END;
$$;

CALL GetCustomersByCity('New York');

