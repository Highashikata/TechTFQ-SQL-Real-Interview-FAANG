-- Create the inventory_events table
CREATE TABLE inventory_events (
    ID VARCHAR(10),
    OnHandQuantity INT,
    OnHandQuantityDelta INT,
    event_type VARCHAR(10),
    event_datetime TIMESTAMP
);



-- Insert the data
INSERT INTO inventory_events (ID, OnHandQuantity, OnHandQuantityDelta, event_type, event_datetime) VALUES
('TR0013', 278, 99, 'OutBound', '2020-05-25 00:25'),
('TR0012', 377, 31, 'InBound', '2020-05-24 22:00'),
('TR0011', 346, 1, 'OutBound', '2020-05-24 15:01'),
('TR0010', 346, 1, 'OutBound', '2020-05-23 05:00'),
('TR0009', 348, 102, 'InBound', '2020-05-25 18:00'),
('TR0008', 246, 43, 'InBound', '2020-04-25 02:00'),
('TR0007', 203, 2, 'OutBound', '2020-02-25 09:00'),
('TR0006', 205, 129, 'OutBound', '2020-02-18 07:00'),
('TR0005', 334, 1, 'OutBound', '2020-02-18 08:00'),
('TR0004', 335, 27, 'OutBound', '2020-01-29 05:00'),
('TR0003', 362, 120, 'InBound', '2019-12-31 02:00'),
('TR0002', 242, 8, 'OutBound', '2019-05-22 05:00'),
('TR0001', 250, 250, 'InBound', '2019-05-20 00:45');
