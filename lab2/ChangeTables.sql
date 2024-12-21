ALTER TABLE products
    ALTER COLUMN hasdelivery SET DEFAULT FALSE;

ALTER TABLE products
    ADD COLUMN description TEXT;

ALTER TABLE products
    ALTER COLUMN price TYPE DECIMAL(10, 2);

ALTER TABLE orderdelivery
    ALTER COLUMN trackingnumber TYPE VARCHAR(15);

ALTER TABLE orderdelivery
    ADD CONSTRAINT orderdelivery_trackingnumber_unique UNIQUE (trackingnumber);

ALTER TABLE orders
    ADD COLUMN PaymentMethod VARCHAR(30);

ALTER TABLE orders
    ADD CONSTRAINT orders_paymentmethod_check
        CHECK (PaymentMethod IN ('Credit Card', 'Cash', 'Bank Transfer'));

CREATE INDEX index_orders_date ON orders (orderdate);

ALTER TABLE products
    ADD CONSTRAINT products_price_check
        CHECK (price > 0.0);

ALTER TABLE products
    DROP CONSTRAINT products_price_check;

ALTER TABLE customers
    RENAME COLUMN contactinfo TO email;

ALTER TABLE products
    DROP COLUMN description;

ALTER TABLE orders
    DROP CONSTRAINT orders_paymentmethod_check;

ALTER TABLE orders
    DROP COLUMN paymentmethod;

ALTER TABLE orderdelivery
    DROP CONSTRAINT orderdelivery_trackingnumber_unique;

CREATE TABLE orderdeliverystatus
(
    OrderDeliveryStatusID SERIAL PRIMARY KEY,
    OrderDeliveryID       INT REFERENCES OrderDelivery (OrderDeliveryID) ON DELETE CASCADE,
    Status                VARCHAR(255) NOT NULL,
    StatusDate            DATE DEFAULT CURRENT_DATE
);

DROP TABLE orderdeliverystatus;