
## INDIAN CYBERSECURITY & CERT-IN INCIDENT ANALYSIS

CREATE DATABASE indian_cybersecurity_analysis;
USE indian_cybersecurity_analysis;

CREATE TABLE cyber_incidents (
    year INT,
    number_of_incidents INT
);

INSERT INTO cyber_incidents (year, number_of_incidents)
VALUES
(2020, 1158208),
(2021, 1402809),
(2022, 1391457),
(2023, 1592917),
(2024, 2041360);

SELECT *
FROM cyber_incidents;

CREATE TABLE incident_types (
    incident_type VARCHAR(100),
    incidents INT
);

INSERT INTO incident_types (incident_type, incidents)
VALUES
('Phishing', 785),
('Unauthorized Network Scanning / Probing', 1610608),
('Vulnerable Services', 294908),
('Virus / Malicious Code', 119763),
('Website Defacements', 5496),
('Website Intrusion & Malware Propagation', 1246),
('Others', 8554);

SELECT *
FROM incident_types;

-- Query 1: Total Incidents (2020–2024) --
SELECT
    SUM(number_of_incidents) AS total_incidents
FROM cyber_incidents;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT year) AS unique_years,
    MIN(year) AS first_year,
    MAX(year) AS last_year,
    SUM(number_of_incidents) AS total_incidents
FROM cyber_incidents;

-- Check for NULL values --
SELECT
    SUM(year IS NULL) AS null_years,
    SUM(number_of_incidents IS NULL) AS null_incident_values
FROM cyber_incidents;

-- Check for duplicate years --
SELECT
    year,
    COUNT(*) AS year_count
FROM cyber_incidents
GROUP BY year
HAVING COUNT(*) > 1;

-- Validate Table 2 total --
SELECT
    SUM(incidents) AS incident_type_total
FROM incident_types;

-- Find the year with the highest incidents --
SELECT
    year,
    number_of_incidents
FROM cyber_incidents
ORDER BY number_of_incidents DESC
LIMIT 1;

-- Find the year with the lowest incidents --
SELECT
    year,
    number_of_incidents
FROM cyber_incidents
ORDER BY number_of_incidents ASC
LIMIT 1;

-- Year-over-Year Incident Change --
SELECT
    year,
    number_of_incidents,
    LAG(number_of_incidents) OVER (ORDER BY year) AS previous_year_incidents,
    number_of_incidents
        - LAG(number_of_incidents) OVER (ORDER BY year) AS change_from_previous_year
FROM cyber_incidents
ORDER BY year;

-- Year-over-Year Growth % --
SELECT
    year,
    number_of_incidents,
    LAG(number_of_incidents) OVER (ORDER BY year) AS previous_year_incidents,
    ROUND(
        (
            number_of_incidents
            - LAG(number_of_incidents) OVER (ORDER BY year)
        ) * 100.0
        / LAG(number_of_incidents) OVER (ORDER BY year),
        2
    ) AS yoy_growth_percent
FROM cyber_incidents
ORDER BY year;

-- Rank Incident Types --
SELECT
    incident_type,
    incidents,
    RANK() OVER (ORDER BY incidents DESC) AS incident_rank
FROM incident_types
ORDER BY incidents DESC;

-- Top 3 Incident Types --
SELECT
    incident_type,
    incidents
FROM incident_types
ORDER BY incidents DESC
LIMIT 3;

-- Percentage Contribution by Incident Type --
SELECT
    incident_type,
    incidents,
    ROUND(
        incidents * 100.0 / SUM(incidents) OVER (),
        2
    ) AS percentage_of_total
FROM incident_types
ORDER BY incidents DESC;

-- Cumulative Percentage --
SELECT
    incident_type,
    incidents,
    ROUND(
        SUM(incidents) OVER (
            ORDER BY incidents DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) * 100.0 / SUM(incidents) OVER (),
        2
    ) AS cumulative_percentage
FROM incident_types
ORDER BY incidents DESC;

-- Compare 2024 Total with Incident-Type Breakdown --
SELECT
    (SELECT number_of_incidents
     FROM cyber_incidents
     WHERE year = 2024) AS reported_2024_total,

    (SELECT SUM(incidents)
     FROM incident_types) AS incident_type_total;

-- Calculate 2020–2024 Overall Growth --
SELECT
    MIN(year) AS start_year,
    MAX(year) AS end_year,
    MIN(number_of_incidents) AS start_year_incidents,
    MAX(CASE WHEN year = 2024 THEN number_of_incidents END) AS end_year_incidents,
    MAX(CASE WHEN year = 2024 THEN number_of_incidents END)
        - MIN(CASE WHEN year = 2020 THEN number_of_incidents END) AS total_increase,
    ROUND(
        (
            MAX(CASE WHEN year = 2024 THEN number_of_incidents END)
            - MIN(CASE WHEN year = 2020 THEN number_of_incidents END)
        ) * 100.0
        / MIN(CASE WHEN year = 2020 THEN number_of_incidents END),
        2
    ) AS overall_growth_percent
FROM cyber_incidents;

-- Average Annual Incidents --
SELECT
    ROUND(AVG(number_of_incidents), 2) AS average_annual_incidents
FROM cyber_incidents;

-- Years Above the 5-Year Average --
WITH average_incidents AS (
    SELECT AVG(number_of_incidents) AS avg_incidents
    FROM cyber_incidents
)
SELECT
    c.year,
    c.number_of_incidents,
    ROUND(a.avg_incidents, 2) AS five_year_average
FROM cyber_incidents c
CROSS JOIN average_incidents a
WHERE c.number_of_incidents > a.avg_incidents
ORDER BY c.number_of_incidents DESC;
