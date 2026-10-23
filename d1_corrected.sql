-- d1_corrected.sql: regions whose completed-order revenue exceeds 80000, highest first.
SELECT c.region,
       SUM(o.amount) AS revenue
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
WHERE o.status = 'completed'
GROUP BY c.region
HAVING SUM(o.amount) > 80000
ORDER BY revenue DESC;
