-- Business question: How did each region perform by order month?
-- INNER JOIN is used because the report covers only completed orders, and every order has a matching customer, so no orders are lost.
-- DISTINCT is necessary because one customer can place multiple orders in the same region and month.

SELECT c.region,o.order_month,
    COUNT(o.order_id) AS number_of_orders,
    COUNT(DISTINCT o.customer_id) AS number_of_customers,
    SUM(o.amount) AS total_revenue,
    AVG(o.amount) AS average_revenue
FROM orders o
INNER JOIN customers c
    ON o.customer_id = c.customer_id
WHERE o.status = 'completed'
GROUP BY c.region, o.order_month
ORDER BY c.region, o.order_month;
