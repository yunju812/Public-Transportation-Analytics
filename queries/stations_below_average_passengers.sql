
SELECT station_id, SUM(passenger_count) AS total_passengers
FROM Rides
GROUP BY station_id
HAVING SUM(passenger_count) < (
    SELECT AVG(total_passengers)
    FROM (
        SELECT SUM(passenger_count) AS total_passengers
        FROM Rides
        GROUP BY station_id
    ) AS station_totals
);
