-- Begin by defining the DAY1 as a reference 

WITH 
	WH AS(
		SELECT * FROM INVENTORY_EVENTS ORDER BY event_datetime desc
	)
	, DAYS AS(
		SELECT 
			onhandquantity
			, event_datetime
			, (event_datetime - interval '90 DAY') as day90
			, (event_datetime - interval '180 DAY') as day180
			, (event_datetime - interval '270 DAY') as day270
			, (event_datetime - interval '365 DAY') as day365
		FROM WH limit 1
	)
	, inventory_90_days AS(
		SELECT 
			SUM(onhandquantitydelta) AS _0_90_days_old
		FROM 
			WH 
		CROSS JOIN 
			DAYS d
		WHERE 
			event_type = 'InBound' AND WH.event_datetime >= d.day90
	)
	-- We put this CTE to handle the logic when comparing the lastest available quantity and our 90_days inventory
	, inventory_90_days_final AS(
		SELECT 
			CASE 
				WHEN _0_90_days_old > d.onhandquantity then d.onhandquantity
				ELSE _0_90_days_old 
			END _0_90_days_old
		FROM 
			inventory_90_days
		CROSS JOIN 
			days d
	)
	, inventory_180_days AS(
		SELECT 
			SUM(onhandquantitydelta) AS _0_180_days_old
		FROM 
			WH 
		CROSS JOIN 
			DAYS d
		WHERE event_type = 'InBound' AND WH.event_datetime BETWEEN d.day180 AND d.day90
	)
	, inventory_180_days_final AS(
		SELECT 
			CASE 
				WHEN _0_180_days_old > (d.onhandquantity - _0_90_days_old) then (d.onhandquantity - _0_90_days_old)
				ELSE _0_180_days_old 
			END _0_180_days_old
		FROM 
			inventory_180_days
		CROSS JOIN 
			days d
		CROSS JOIN
			inventory_90_days_final
	)
	
	, inventory_270_days AS(
		SELECT 
			SUM(onhandquantitydelta) AS _0_270_days_old
		FROM 
			WH 
		CROSS JOIN 
			DAYS d
		WHERE 
			event_type = 'InBound' AND WH.event_datetime BETWEEN d.day180 AND d.day270
	)
	, inventory_270_days_final AS(
		SELECT 
			CASE 
				WHEN _0_270_days_old > (d.onhandquantity - _0_180_days_old) then (d.onhandquantity - _0_180_days_old)
				ELSE _0_270_days_old 
			END _0_270_days_old
		FROM 
			inventory_270_days
		CROSS JOIN 
			days d
		CROSS JOIN
			inventory_180_days_final
	)
	, inventory_365_days AS(
		SELECT 
			SUM(onhandquantitydelta) AS _0_365_days_old
		FROM 
			WH 
		CROSS JOIN 
			DAYS d
		WHERE 
			event_type = 'InBound' AND WH.event_datetime BETWEEN d.day270 AND d.day365
	)
	, inventory_365_days_final AS(
		SELECT 
			CASE 
				WHEN _0_365_days_old > (d.onhandquantity - _0_270_days_old) then (d.onhandquantity - _0_270_days_old)
				ELSE _0_365_days_old 
			END _0_365_days_old
		FROM 
			inventory_365_days
		CROSS JOIN 
			days d
		CROSS JOIN
			inventory_270_days_final
	)
		
SELECT 
	  COALESCE(_0_90_days_old, 0) AS "0-90 days old"
	, COALESCE(_0_180_days_old, 0) AS "91-180 days old"
	, COALESCE(_0_270_days_old, 0) AS "181-270 days old"
	, COALESCE(_0_365_days_old, 0) AS "271-365 days old"
FROM 
	inventory_90_days_final
CROSS JOIN
	inventory_180_days_final
CROSS JOIN
	inventory_270_days_final
CROSS JOIN
	inventory_365_days_final

