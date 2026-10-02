# IT Service Desk Performance Analysis

## Project Overview

This project analyzes 1,000 IT service desk support tickets using MySQL to evaluate 
ticket volume, response times, resolution performance, customer satisfaction, and 
unresolved ticket backlog.

The analysis identifies operational patterns across ticket priority, category, channel, 
and status to provide data-driven insights into service desk performance.

## Objectives

- Analyze overall service desk ticket volume
- Measure first response and resolution times
- Compare performance across ticket priorities
- Analyze ticket categories and support channels
- Evaluate customer satisfaction
- Identify unresolved ticket backlog
- Calculate ticket resolution rates
- Identify long-response and long-resolution tickets
- Analyze monthly service desk performance

## Tools & Technologies

- MySQL 8.0
- MySQL Workbench
- SQL
- GitHub

## Dataset

The dataset contains 1,000 individual IT support tickets with the following fields:

- Ticket ID
- Created Date
- Customer ID
- Channel
- Priority
- Category
- First Response Time
- Resolution Time
- Status
- Satisfaction Score

## Data Preparation

The dataset was prepared in MySQL by:

- Importing the ticket-level CSV dataset
- Cleaning empty values
- Converting numeric columns to appropriate data types
- Converting the original timestamp into a usable DATETIME field
- Validating ticket counts and customer records

## SQL Analysis

The project includes analysis of:

### Ticket Volume
- Total tickets
- Monthly ticket volume
- Unique customers

### Ticket Distribution
- Tickets by priority
- Tickets by category
- Tickets by support channel
- Tickets by status

### Service Performance
- Average first response time
- Average resolution time
- Resolution time by priority
- Resolution time by category
- Response time by channel
- Monthly response and resolution trends

### Customer Satisfaction
- Satisfaction score distribution
- Average satisfaction by channel
- Average satisfaction by priority
- Satisfaction compared with resolution time

### Backlog Analysis
- Unresolved tickets by priority
- Unresolved tickets by category
- Unresolved tickets by channel
- Oldest unresolved tickets

### Performance Metrics
- Overall resolution rate
- Resolution rate by priority
- Tickets exceeding 60-minute first-response threshold
- Resolved/closed tickets exceeding 24-hour resolution threshold

## Key Business Insights

- The overall ticket resolution rate was **83.50%**, with 835 of 1,000 tickets resolved 
or closed.
- **165 tickets remained unresolved**, indicating a measurable support backlog.
- **53.30% of tickets had a first response time exceeding 60 minutes.**
- **48.74% of resolved or closed tickets took more than 24 hours to resolve.**
- Average first response time was **108.46 minutes**.
- Average resolution time was **2,016.89 minutes**.
- Average customer satisfaction was **2.97 out of 5**.
- Low-priority tickets had the longest average resolution time at **4,769.89 minutes**.
- Chat had the highest number of unresolved tickets, with **38 tickets**.
- Monthly resolution rates ranged from **78.31% to 90.36%**.
- Resolution performance varied across ticket priorities and categories.

## Conclusion

This project demonstrates how SQL can be used to analyze IT service desk data, measure 
operational performance, identify support backlogs, and generate data-driven business 
insights.

## Skills Demonstrated

- SQL
- MySQL
- Data Cleaning
- Data Analysis
- Aggregation
- GROUP BY
- CASE Statements
- Date Functions
- Subqueries
- KPI Analysis
- Business Insights










