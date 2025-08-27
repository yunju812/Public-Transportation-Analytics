CREATE DATABASE transit;
USE transit;

CREATE TABLE Stations (
    station_id INT PRIMARY KEY,
    station_name VARCHAR(100),
    location VARCHAR(100),
    line_id INT,
    FOREIGN KEY (line_id) REFERENCES Lines_(line_id)
);

CREATE TABLE Lines_ (
    line_id INT PRIMARY KEY,
    line_name VARCHAR(50),
    line_type VARCHAR(20)
);

CREATE TABLE Rides (
    ride_id INT PRIMARY KEY,
    station_id INT,
    line_id INT,
    ride_date DATE,
    passenger_count INT,
    FOREIGN KEY (station_id) REFERENCES Stations(station_id),
    FOREIGN KEY (line_id) REFERENCES Lines_(line_id)
);
