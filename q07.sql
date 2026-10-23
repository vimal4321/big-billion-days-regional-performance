-- Business question: Which products generated more than INR 20,000 in completed revenue?

SELECT item,COUNT(order_id) AS number_of_orders,SUM(amount) AS revenue
FROM orders
WHERE status = 'completed'
GROUP BY item
HAVING SUM(amount) > 20000
ORDER BY revenue DESC;
