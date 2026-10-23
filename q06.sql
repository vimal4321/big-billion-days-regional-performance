-- Business question: How many orders and how much order value exist in each status?

SELECT status,COUNT(order_id) AS number_of_orders,SUM(amount) AS total_amount
FROM orders
GROUP BY status
ORDER BY number_of_orders DESC;
