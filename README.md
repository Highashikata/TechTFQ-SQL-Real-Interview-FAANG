# TechTFQ-SQL-Real-Interview-FAANG
REAL SQL Interview Question by a FAANG company


We want to generate an inventory age report which would show the distribution of remaining inventory across the length of time the inventory has been sitting at the warehouse. We are trying to classify the inventory on hand across the below 4 buckets to denote the time the inventory has been lying in the warehouse.

0-90 days old
91-180 days old
181-270 days old
271-365 days old
For example, the warehouse received 100 units yesterday and shipped 30 units today, then there are 70 units which are a day old.

The warehouses use FIFO (first in, first out) approach to manage inventory, i.e., the inventory that comes first will be sent out first.

![image](https://github.com/user-attachments/assets/2cfa6f22-7648-4ddb-bfbd-f217df6cfb56)


For example, on 20th May 2019, 250 units were inbounded into the FC. On 22nd May 2019, 8 units were shipped out (outbound) from the FC, reducing inventory on hand to 242 units. On 31st December, 120 units were further inbounded into the FC increasing the inventory on hand from 242 to 362. On 29th January 2020, 27 units were shipped out reducing the inventory on hand to 335 units.
On 29th January, of the 335 units on hand, 120 units were 0-90 days old (29 days old) and 215 units were 181-270 days old (254 days old).

Columns:

ID of the log entry
OnHandQuantity: Quantity in warehouse after an event
OnHandQuantityDelta: Change in on-hand quantity due to an event
event_type: Inbound – inventory being brought into the warehouse; Outbound – inventory being sent out of warehouse
event_datetime: date-time of event
The data is sorted with the latest entry at the top.

**Expected Output**

![image](https://github.com/user-attachments/assets/e0716037-68f7-4412-8cde-86a1255f20d7)



**THE SQL scripts**

```
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

```

**This is the SQL Script that I first wrote**

```
-- on va commencer par définir la première ligne comme le (DAY 1), après on commencera à calculer la différence de jour 

WITH 
	DAY_1 AS(
		SELECT 
			MAX(EVENT_DATETIME)
		FROM 
			INVENTORY_EVENTS
	) 

	-- par rapport à ce 2ème CTE, on va calculer la différence entre les event_datetime et le DAY1
	, DATE_BINS AS(
		SELECT id
			, onhandquantity
			, onhandquantitydelta
			, event_type
			, event_datetime
			, CASE 
				WHEN EXTRACT(DAY FROM (SELECT MAX(event_datetime) FROM inventory_events) - event_datetime) + 1 BETWEEN 0 AND 90 THEN '0-90 days'
				WHEN EXTRACT(DAY FROM (SELECT MAX(event_datetime) FROM inventory_events) - event_datetime) + 1 BETWEEN 91 AND 180 THEN '91-180 days'
				WHEN EXTRACT(DAY FROM (SELECT MAX(event_datetime) FROM inventory_events) - event_datetime) + 1 BETWEEN 181 AND 270 THEN '181-270 days'
				WHEN EXTRACT(DAY FROM (SELECT MAX(event_datetime) FROM inventory_events) - event_datetime) + 1 BETWEEN 271 AND 365 THEN '271-365 days'
			ELSE '>365 days'
			END AS date_diff
			,CASE 
				WHEN EVENT_TYPE = 'OutBound' THEN - onhandquantitydelta
				ELSE + onhandquantitydelta
			END AS FLAG 
		FROM
			INVENTORY_EVENTS
	)
	
	
SELECT * FROM DATE_BINS;
	
SELECT 
	date_diff, COUNT(flag) 
FROM 
	DATE_BINS
GROUP BY 
	date_diff
order by date_diff desc
```

**Then this is the correction I've been through**

```

```




