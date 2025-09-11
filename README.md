# Public Transportation Analytics

**Note:** All data in this project is simulated for demonstration purposes.

## Executive Summary

This project demonstrates the use of MySQL to analyze public transportation data, uncovering key insights about ridership patterns, station usage, and line performance. Through advanced SQL queries, joins, aggregations, and window functions, it identifies high-traffic and underutilized stations, evaluates ridership trends over time, and provides data-driven recommendations for optimizing urban transit.

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

Note: Each row represents the daily total passengers for a specific station and line, not a single vehicle trip.

## Key SQL Concepts Used

- Joins to combine related tables  
- Aggregations and subqueries for totals, averages, and filtering  
- Window functions (e.g., RANK()) for ranking stations within each line  
- Analysis of ridership trends over time, across stations, and by line/type  

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
Note: CURDATE() - INTERVAL 30 DAY selects rides from the last 30 days relative to when the query is run. For reproducibility, the equivalent fixed date would be '2025-08-12'
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
## Insights
1. **Top 5 stations by total passengers**  
       LumaCity, SolisCity, NovaPort, TerraCity, and ValeCity are the busiest stations, highlighting key hubs where service improvements or capacity expansions could have the greatest impact.
2. **Average ridership by line type**              
   Bus lines have the highest average ridership, followed by subway and tram lines. Lower tram usage may reflect limited coverage or less convenient routes rather than low demand, highlighting areas for               potential network optimization.
3. **Daily ridership trend**              
   Daily passenger totals fluctuate throughout the period, with peaks on 8/17/25 (3504 passengers) and 8/23/25 (3223 passengers). This highlights variability in daily usage and suggests that service planning should account for periodic spikes in ridership.
4. **Total passengers per line**                      
       The Yellow line leads ridership (109,601 passengers), closely followed by the Purple (106,552) and Red (100,633) lines. This indicates that these three lines carry the bulk of passenger demand, while Green and Blue serve comparatively fewer riders.
5. **Ridership rank per line**         
       Each line has a few hub stations that dominate ridership. For example, Station 5 leads Line 1, Station 14 leads Line 2, Station 12 leads Line 3, Station 18 leads Line 4, and Station 3 leads Line 5. These hubs handle a disproportionate share of passengers, making them critical points for resource allocation and planning.
6. **Stations below average per passengers**               
       Among below-average stations, the weakest performers are Stations 17 and 19 (≈14,600 passengers each), while others like Station 15 (24,154) and Station 6 (23,453), though still under average, manage relatively higher usage. This highlights that not all “below-average” stations are equally underutilized — some are closer to the system mean, while others may need closer evaluation.

