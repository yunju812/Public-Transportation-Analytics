SELECT Rides.line_id,
       Rides.station_id,
       SUM(Rides.passenger_count) AS total_passengers,
       RANK() OVER (PARTITION BY Rides.line_id ORDER BY SUM(Rides.passenger_count) DESC)
FROM Rides
GROUP BY Rides.line_id, Rides.station_id;
