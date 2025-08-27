SELECT station_name,
       SUM(Rides.passenger_count) AS total_passengers
FROM Rides
JOIN Stations ON Rides.station_id = Stations.station_id
GROUP BY station_name
ORDER BY SUM(Rides.passenger_count) DESC
LIMIT 5;