# Public Transportation Analytics

**Note:** All data in this project is simulated for demonstration purposes.

This project analyzes public transportation usage and trends using a MySQL database. The dataset includes three interconnected tables:

## Dataset Structure

**Stations** – Information about transit stations  
- station_id (INT, Primary Key)  
- station_name (VARCHAR)  
- line_id (INT, Foreign Key)  
- location (VARCHAR)  

**Lines_** – Details on transit lines  
- line_id (INT, Primary Key)  
- line_name (VARCHAR)  
- line_type (VARCHAR)  

**Rides** – Daily ride counts per station and line  
- ride_id (INT, Primary Key)  
- station_id (INT, Foreign Key)  
- line_id (INT, Foreign Key)  
- ride_date (DATE)  
- passenger_count (INT)  

## Key SQL Concepts Used

- Joins to combine related tables  
- Aggregations and subqueries for totals, averages, and filtering  
- Window functions (e.g., RANK()) for ranking stations within each line  
- Analysis of ridership trends over time, across stations, and by line/type  

## Insights & Applications

By analyzing this dataset, you can:  
- Identify the busiest stations and lines for targeted improvements  
- Spot underutilized stations and lines for service adjustments  
- Evaluate ridership trends over time to support scheduling and resource allocation  
- Rank stations within lines to prioritize infrastructure investments  
- Provide data-driven recommendations for urban transit planning  

## Sample Queries

**Top 5 stations by total passengers**  
```sql
SELECT station_name,
       SUM(Rides.passenger_count) AS total_passengers
FROM Rides
JOIN Stations ON Rides.station_id = Stations.station_id
GROUP BY station_name
ORDER BY total_passengers DESC
LIMIT 5;
```
**Average ridership by line type**  
```sql
SELECT lines_.line_type,
       AVG(Rides.passenger_count)
FROM Rides
JOIN Lines_ ON Rides.line_id = Lines_.line_id
GROUP BY Lines_.line_type
ORDER BY AVG(Rides.passenger_count) DESC;
```

**Daily ridership trend**  
```sql
SELECT ride_date,
       SUM(passenger_count) AS total_passengers
FROM Rides
WHERE ride_date >= CURDATE() - INTERVAL 30 DAY
GROUP BY ride_date
ORDER BY ride_date;
```

**Total passengers per line**  
```sql
SELECT Lines_.line_name,
       SUM(Rides.passenger_count) AS total_passengers
FROM Rides
JOIN Lines_ ON Rides.line_id = Lines_.line_id
GROUP BY Lines_.line_name
ORDER BY SUM(Rides.passenger_count) DESC;
```

**Ridership rank per line**  
```sql
SELECT Rides.line_id,
       Rides.station_id,
       SUM(Rides.passenger_count) AS total_passengers,
       RANK() OVER (PARTITION BY Rides.line_id ORDER BY SUM(Rides.passenger_count) DESC)
FROM Rides
GROUP BY Rides.line_id, Rides.station_id;
```

**Stations below average per passengers**  
```sql
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
```
