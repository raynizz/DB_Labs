CREATE ROLE administrator WITH LOGIN PASSWORD '1234';
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO administrator;

CREATE ROLE sales_manager WITH LOGIN PASSWORD 's1234';
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE Orders, orderitems, contracts, customers
    TO sales_manager;

CREATE ROLE logistic_manager WITH LOGIN PASSWORD 'l1234';
GRANT SELECT, UPDATE ON TABLE OrderDelivery, DeliveryOptions
    TO logistic_manager;

REVOKE SELECT, INSERT, UPDATE, DELETE ON TABLE Orders, orderitems, contracts, customers
    FROM sales_manager;