SELECT Lines_.line_name,
       SUM(Rides.passenger_count) AS total_passengers
FROM Rides
JOIN Lines_ ON Rides.line_id = Lines_.line_id
GROUP BY Lines_.line_name
ORDER BY SUM(Rides.passenger_count) DESC;
