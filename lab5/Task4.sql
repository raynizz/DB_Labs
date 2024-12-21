CREATE TABLE LogTable
(
    LogID     SERIAL PRIMARY KEY,
    Message   TEXT,
    EventTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Тригер на видалення продукту
CREATE FUNCTION on_product_delete()
    RETURNS TRIGGER AS
$$
BEGIN
    INSERT INTO LogTable (Message)
    VALUES (format('Product with ID %s has been deleted.', OLD.ProductID));
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER product_delete_trigger
    AFTER DELETE
    ON Products
    FOR EACH ROW
EXECUTE FUNCTION on_product_delete();

INSERT INTO Products (Name, Price, Manufacturer, WarehouseLocation)
VALUES ('Product1', 100, 'Manufacturer1', 'Location1');

DELETE
FROM Products
WHERE ProductID = 50;

SELECT *
FROM LogTable;

DROP TRIGGER product_delete_trigger ON Products;
DROP FUNCTION on_product_delete;
DROP TABLE LogTable;

-- Тригер на оновлення продукту
CREATE FUNCTION on_product_update()
    RETURNS TRIGGER AS
$$
BEGIN
    INSERT INTO LogTable (Message)
    VALUES (format('Product with ID %s has been updated.', NEW.ProductID));
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER product_update_trigger
    AFTER UPDATE
    ON Products
    FOR EACH ROW
EXECUTE FUNCTION on_product_update();

UPDATE Products SET Price = 200 WHERE ProductID = 51;

-- Тригер на вставку продукту
CREATE FUNCTION on_product_insert()
    RETURNS TRIGGER AS
$$
BEGIN
    INSERT INTO LogTable (Message)
    VALUES (format('Product with ID %s has been inserted.', NEW.ProductID));
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER product_insert_trigger
    AFTER INSERT
    ON Products
    FOR EACH ROW
EXECUTE FUNCTION on_product_insert();

INSERT INTO Products (Name, Price, Manufacturer, WarehouseLocation) VALUES ('Product2', 200, 'Manufacturer2', 'Location2');