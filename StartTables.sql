CREATE TABLE Products
(
    ProductID         SERIAL PRIMARY KEY,
    Name              VARCHAR(255) NOT NULL,
    Price             FLOAT        NOT NULL,
    Manufacturer      VARCHAR(255),
    HasDelivery       BOOLEAN DEFAULT TRUE,
    WarehouseLocation VARCHAR(255)
);

CREATE TABLE Customers
(
    CustomerID      SERIAL PRIMARY KEY,
    Name            VARCHAR(255) NOT NULL,
    ContactInfo     VARCHAR(255),
    DeliveryAddress VARCHAR(255)
);

CREATE TABLE Contracts
(
    ContractID SERIAL PRIMARY KEY,
    CustomerID INT REFERENCES Customers (CustomerID) ON DELETE CASCADE,
    StartDate  DATE NOT NULL,
    EndDate    DATE
);

CREATE TABLE Orders
(
    OrderID      SERIAL PRIMARY KEY,
    ContractID   INT REFERENCES Contracts (ContractID) ON DELETE CASCADE,
    OrderDate    DATE  NOT NULL,
    TotalAmount  FLOAT NOT NULL,
    DeliveryCost FLOAT,
    FinalAmount  FLOAT
);

CREATE TABLE OrderItems
(
    OrderItemID  SERIAL PRIMARY KEY,
    OrderID      INT REFERENCES Orders (OrderID) ON DELETE CASCADE,
    ProductID    INT REFERENCES Products (ProductID) ON DELETE CASCADE,
    Quantity     INT   NOT NULL,
    PriceAtOrder FLOAT NOT NULL,
    Subtotal     FLOAT NOT NULL
);

CREATE TABLE DeliveryOptions
(
    DeliveryOptionID SERIAL PRIMARY KEY,
    ProductID        INT REFERENCES Products (ProductID) ON DELETE CASCADE,
    DeliveryType     VARCHAR(255),
    DeliveryPrice    FLOAT NOT NULL,
    DeliveryTime     VARCHAR(255)
);

CREATE TABLE OrderDelivery
(
    OrderDeliveryID    SERIAL PRIMARY KEY,
    OrderID            INT REFERENCES Orders (OrderID) ON DELETE CASCADE,
    DeliveryOptionID   INT REFERENCES DeliveryOptions (DeliveryOptionID) ON DELETE CASCADE,
    ActualDeliveryDate DATE,
    Status             VARCHAR(255),
    TrackingNumber     VARCHAR(255)
);