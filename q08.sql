-- Business question: What is the customer age profile in each region?

SELECT region,COUNT(customer_id) AS number_of_customers,
    AVG(age) AS average_age,MIN(age) AS min_age,MAX(age) AS max_age
FROM customers
GROUP BY region
ORDER BY region ASC;
