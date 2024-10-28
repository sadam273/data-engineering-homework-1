
--count records
SELECT COUNT(*) 
FROM green_taxi_data gtd 
WHERE DATE(lpep_pickup_datetime) = '2019-09-18' 
AND DATE(lpep_dropoff_datetime) = '2019-09-18';

--longest trip
SELECT
    DATE(lpep_pickup_datetime) AS day
FROM
    green_taxi_data gtd
WHERE
    (lpep_dropoff_datetime - lpep_pickup_datetime) = (
        SELECT MAX(lpep_dropoff_datetime - lpep_pickup_datetime)
        FROM green_taxi_data
    );
   

--bourough that has > 50000 total amount in 2019-09-18
SELECT
    tzl."Borough",
    SUM(gtd.total_amount) AS total_amount
FROM
    green_taxi_data gtd
INNER JOIN taxi_zone_lookup tzl ON gtd."PULocationID" = tzl."LocationID"
WHERE
    DATE(lpep_pickup_datetime) = '2019-09-18'
    AND tzl."Borough" != 'Unknown'
GROUP BY
    tzl."Borough"
HAVING
    SUM(gtd.total_amount) > 50000
ORDER BY
    total_amount DESC
LIMIT 3;

--For the passengers picked up in September 2019 in the zone name 
--Astoria which was the drop off zone that had the largest tip? We want the name of the zone, not the id.
SELECT
    tzl."Zone",
    DATE(gtd.lpep_pickup_datetime) AS day,
    MAX(gtd.tip_amount) AS max_tip
FROM
    green_taxi_data gtd
INNER JOIN taxi_zone_lookup tzl ON gtd."DOLocationID" = tzl."LocationID"
WHERE
    DATE_TRUNC('month', gtd.lpep_pickup_datetime) = '2019-09-01' and 
    gtd."PULocationID" = 7
GROUP BY
    DATE(gtd.lpep_pickup_datetime), tzl."Zone"
ORDER BY
    max_tip desc ;
    
