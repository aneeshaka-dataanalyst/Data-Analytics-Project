
-- IT SERVICE DESK PERFORMANCE ANALYSIS --

CREATE DATABASE service_desk_analysis;
USE service_desk_analysis;

-- Change the data types --
ALTER TABLE support_tickets
MODIFY customer_id INT,
MODIFY first_response_min INT,
MODIFY resolution_min DECIMAL(10,2),
MODIFY satisfaction DECIMAL(3,1);

ALTER TABLE support_tickets
ADD COLUMN created_datetime DATETIME;

UPDATE support_tickets
SET created_datetime =
    STR_TO_DATE(
        REPLACE(REPLACE(created_at, 'T', ' '), 'Z', ''),
        '%Y-%m-%d %H:%i:%s'
    );

-- overall ticket volume --
SELECT 
    COUNT(*) AS total_tickets
FROM support_tickets;

SELECT 
    COUNT(DISTINCT customer_id) AS unique_customers
FROM support_tickets;

SELECT 
    MIN(created_datetime) AS first_ticket,
    MAX(created_datetime) AS latest_ticket
FROM support_tickets;

-- Monthly ticket volume --
SELECT
    DATE_FORMAT(created_datetime, '%Y-%m') AS month,
    COUNT(*) AS ticket_count
FROM support_tickets
GROUP BY DATE_FORMAT(created_datetime, '%Y-%m')
ORDER BY month;

-- Ticket volume by priority --
SELECT
    priority,
    COUNT(*) AS ticket_count
FROM support_tickets
GROUP BY priority
ORDER BY ticket_count DESC;

-- Analyze ticket categories --
SELECT
    category,
    COUNT(*) AS ticket_count
FROM support_tickets
GROUP BY category
ORDER BY ticket_count DESC;

-- Ticket status analysis --
SELECT
    status,
    COUNT(*) AS ticket_count
FROM support_tickets
GROUP BY status
ORDER BY ticket_count DESC;

-- Average response and resolution time --
SELECT
    ROUND(AVG(first_response_min), 2) AS avg_first_response_min,
    ROUND(AVG(resolution_min), 2) AS avg_resolution_min
FROM support_tickets;

-- Resolution time by priority --
SELECT
    priority,
    COUNT(*) AS ticket_count,
    ROUND(AVG(first_response_min), 2) AS avg_response_min,
    ROUND(AVG(resolution_min), 2) AS avg_resolution_min
FROM support_tickets
GROUP BY priority
ORDER BY avg_resolution_min DESC;

-- Resolution time by category--
SELECT
    category,
    COUNT(*) AS ticket_count,
    ROUND(AVG(first_response_min), 2) AS avg_response_min,
    ROUND(AVG(resolution_min), 2) AS avg_resolution_min
FROM support_tickets
GROUP BY category
ORDER BY avg_resolution_min DESC;

-- Response time by channel --
SELECT
    channel,
    COUNT(*) AS ticket_count,
    ROUND(AVG(first_response_min), 2) AS avg_response_min,
    ROUND(AVG(resolution_min), 2) AS avg_resolution_min
FROM support_tickets
GROUP BY channel
ORDER BY avg_response_min DESC;

-- Customer satisfaction by rating --
SELECT
    satisfaction,
    COUNT(*) AS ticket_count
FROM support_tickets
WHERE satisfaction IS NOT NULL
GROUP BY satisfaction
ORDER BY satisfaction;

-- Average satisfaction by channel --
SELECT
    channel,
    COUNT(*) AS ticket_count,
    ROUND(AVG(satisfaction), 2) AS avg_satisfaction
FROM support_tickets
WHERE satisfaction IS NOT NULL
GROUP BY channel
ORDER BY avg_satisfaction DESC;

-- Satisfaction vs. resolution time --
SELECT
    satisfaction,
    COUNT(*) AS ticket_count,
    ROUND(AVG(resolution_min), 2) AS avg_resolution_min
FROM support_tickets
WHERE satisfaction IS NOT NULL
GROUP BY satisfaction
ORDER BY satisfaction;

-- Open tickets by priority --
SELECT
    priority,
    COUNT(*) AS open_ticket_count
FROM support_tickets
WHERE status IN ('open', 'pending')
GROUP BY priority
ORDER BY open_ticket_count DESC;

-- Open tickets by category --
SELECT
    category,
    COUNT(*) AS open_ticket_count
FROM support_tickets
WHERE status IN ('open', 'pending')
GROUP BY category
ORDER BY open_ticket_count DESC;

-- Overall satisfaction score --
SELECT
    ROUND(AVG(satisfaction), 2) AS overall_avg_satisfaction
FROM support_tickets
WHERE satisfaction IS NOT NULL;

-- Average response and resolution time by status --
SELECT
    status,
    COUNT(*) AS ticket_count,
    ROUND(AVG(first_response_min), 2) AS avg_response_min,
    ROUND(AVG(resolution_min), 2) AS avg_resolution_min
FROM support_tickets
GROUP BY status
ORDER BY avg_resolution_min DESC;

-- Resolution rate --
SELECT
    COUNT(*) AS total_tickets,
    SUM(CASE
        WHEN status IN ('resolved', 'closed') THEN 1
        ELSE 0
    END) AS resolved_tickets,
    ROUND(
        100.0 * SUM(CASE
            WHEN status IN ('resolved', 'closed') THEN 1
            ELSE 0
        END) / COUNT(*),
        2
    ) AS resolution_rate_percent
FROM support_tickets;

-- Resolution rate by priority --
SELECT
    priority,
    COUNT(*) AS total_tickets,
    SUM(CASE
        WHEN status IN ('resolved', 'closed') THEN 1
        ELSE 0
    END) AS resolved_tickets,
    ROUND(
        100.0 * SUM(CASE
            WHEN status IN ('resolved', 'closed') THEN 1
            ELSE 0
        END) / COUNT(*),
        2
    ) AS resolution_rate_percent
FROM support_tickets
GROUP BY priority
ORDER BY resolution_rate_percent DESC;

-- Average satisfaction by priority --
SELECT
    priority,
    COUNT(*) AS ticket_count,
    ROUND(AVG(satisfaction), 2) AS avg_satisfaction
FROM support_tickets
WHERE satisfaction IS NOT NULL
GROUP BY priority
ORDER BY avg_satisfaction DESC;

-- Identify the longest unresolved tickets --
SELECT
    ticket_id,
    customer_id,
    priority,
    category,
    channel,
    status,
    created_datetime
FROM support_tickets
WHERE status IN ('open', 'pending')
ORDER BY created_datetime ASC
LIMIT 10;

-- Unresolved tickets by channel --
SELECT
    channel,
    COUNT(*) AS unresolved_tickets
FROM support_tickets
WHERE status IN ('open', 'pending')
GROUP BY channel
ORDER BY unresolved_tickets DESC;

-- Monthly resolution rate --
SELECT
    DATE_FORMAT(created_datetime, '%Y-%m') AS month,
    COUNT(*) AS total_tickets,
    SUM(CASE
        WHEN status IN ('resolved', 'closed') THEN 1
        ELSE 0
    END) AS resolved_tickets,
    ROUND(
        100.0 * SUM(CASE
            WHEN status IN ('resolved', 'closed') THEN 1
            ELSE 0
        END) / COUNT(*),
        2
    ) AS resolution_rate_percent
FROM support_tickets
GROUP BY DATE_FORMAT(created_datetime, '%Y-%m')
ORDER BY month;

-- Monthly average response and resolution time --
SELECT
    DATE_FORMAT(created_datetime, '%Y-%m') AS month,
    COUNT(*) AS ticket_count,
    ROUND(AVG(first_response_min), 2) AS avg_response_min,
    ROUND(AVG(resolution_min), 2) AS avg_resolution_min
FROM support_tickets
GROUP BY DATE_FORMAT(created_datetime, '%Y-%m')
ORDER BY month;

-- Identify slow-response tickets --
SELECT
    COUNT(*) AS slow_response_tickets,
    ROUND(
        100.0 * COUNT(*) / (SELECT COUNT(*) FROM support_tickets),
        2
    ) AS slow_response_percent
FROM support_tickets
WHERE first_response_min > 60;

-- Identify long-resolution tickets --
SELECT
    COUNT(*) AS long_resolution_tickets,
    ROUND(
        100.0 * COUNT(*) /
        (SELECT COUNT(*)
         FROM support_tickets
         WHERE status IN ('resolved', 'closed')),
        2
    ) AS long_resolution_percent
FROM support_tickets
WHERE status IN ('resolved', 'closed')
  AND resolution_min > 1440;

-- Resolution performance by category and priority --
SELECT
    priority,
    category,
    COUNT(*) AS ticket_count,
    ROUND(AVG(resolution_min), 2) AS avg_resolution_min
FROM support_tickets
WHERE status IN ('resolved', 'closed')
GROUP BY priority, category
ORDER BY avg_resolution_min DESC;

-- Final KPI summary --
SELECT
    COUNT(*) AS total_tickets,

    COUNT(DISTINCT customer_id) AS unique_customers,

    SUM(CASE
        WHEN status IN ('resolved', 'closed') THEN 1
        ELSE 0
    END) AS resolved_tickets,

    SUM(CASE
        WHEN status IN ('open', 'pending') THEN 1
        ELSE 0
    END) AS unresolved_tickets,

    ROUND(
        100.0 * SUM(CASE
            WHEN status IN ('resolved', 'closed') THEN 1
            ELSE 0
        END) / COUNT(*),
        2
    ) AS resolution_rate_percent,

    ROUND(AVG(first_response_min), 2) AS avg_first_response_min,

    ROUND(AVG(resolution_min), 2) AS avg_resolution_min,

    ROUND(AVG(satisfaction), 2) AS avg_satisfaction
FROM support_tickets;

-- FINAL KEY BUSINESS INSIGHT --

-- 1. The overall ticket resolution rate was 83.50%, with 835 of 1,000 tickets resolved or closed.

-- 2. 165 tickets remained unresolved, indicating a measurable support backlog.

-- 3. 53.30% of tickets had a first response time exceeding 60 minutes.

-- 4. 48.74% of resolved or closed tickets took more than 24 hours to resolve.

-- 5. The average first response time was 108.46 minutes, while the average resolution time was 2,016.89 minutes.

-- 6. Average customer satisfaction was 2.97 out of 5.

-- 7. Low-priority tickets had the longest average resolution time at 4,769.89 minutes, compared with 257.78 minutes for urgent tickets.

-- 8. Chat had the highest number of unresolved tickets, with 38 tickets.

-- 9. Monthly resolution rates ranged from 78.31% to 90.36% during the analysis period.

-- 10. Resolution performance varied across ticket priorities and categories, with substantial differences in average resolution time.






