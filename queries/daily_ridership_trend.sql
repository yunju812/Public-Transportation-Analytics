SELECT ride_date,
       SUM(passenger_count) AS total_passengers
FROM Rides
WHERE ride_date >= CURDATE() - INTERVAL 30 DAY
GROUP BY ride_date
ORDER BY ride_date;