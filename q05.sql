-- Business question: What are the headline revenue KPIs for completed orders?

SELECT COUNT(order_id) AS total_orders,SUM(amount) AS total_revenue,
       AVG(amount) AS avg_order_value,MIN(amount) AS min_order_value,
       MAX(amount) AS max_order_value
FROM orders
WHERE status = 'completed';
