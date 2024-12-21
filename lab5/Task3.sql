-- Робота з курсорами (створити процедуру, в котрій демонструються наведені нижче дії):
-- a. створення курсору;
-- b. відкриття курсору;
-- c. вибірка даних;
-- d. робота з курсорами.
CREATE OR REPLACE PROCEDURE ProcessOrdersCursor()
    LANGUAGE plpgsql AS $$
DECLARE
    order_cursor CURSOR FOR
        SELECT OrderID, OrderDate, TotalAmount
        FROM Orders;
    order_record RECORD;
BEGIN
    OPEN order_cursor;

    LOOP
        FETCH order_cursor INTO order_record;
        EXIT WHEN NOT FOUND;

        RAISE NOTICE 'Order ID: %, Order Date: %, Total Amount: %',
            order_record.OrderID,
            order_record.OrderDate,
            order_record.TotalAmount;
    END LOOP;

    CLOSE order_cursor;
END;
$$;

CALL ProcessOrdersCursor();