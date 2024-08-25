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
	
	
SELECT 
	date_diff, SUM(flag) 
FROM 
	DATE_BINS
GROUP BY 
	date_diff
order by date_diff desc