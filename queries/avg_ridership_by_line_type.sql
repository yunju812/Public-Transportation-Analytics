SELECT lines_.line_type,
       AVG(Rides.passenger_count)
FROM Rides
JOIN Lines_ ON Rides.line_id = Lines_.line_id
GROUP BY Lines_.line_type
ORDER BY AVG(Rides.passenger_count) DESC;
