/* --------------------
   Case Study Questions
   --------------------*/

-- 1. What is the total amount each customer spent at the restaurant?

SELECT 
  sales.customer_id, 
  SUM(menu.price) AS total_amount
FROM dannys_diner.sales sales
LEFT JOIN dannys_diner.menu menu
ON sales.product_id = menu.product_id
GROUP BY sales.customer_id
ORDER BY total_amount DESC;


-- 2. How many days has each customer visited the restaurant?

SELECT 
	sales.customer_id,
    COUNT(sales.order_date) AS dias_visitados
FROM dannys_diner.sales 
GROUP BY sales.customer_id
ORDER BY sales.customer_id

-- 3. What was the first item from the menu purchased by each customer?

-- metodo 1
SELECT
    DISTINCT sales.customer_id,
    FIRST_VALUE(menu.product_name) OVER (PARTITION BY sales.customer_id ORDER BY sales.order_date) b
FROM dannys_diner.sales 
LEFT JOIN dannys_diner.menu menu
ON sales.product_id = menu.product_id

-- metodo 2
SELECT customer_id, product_name, order_date
FROM (
    SELECT
        sales.customer_id,
        menu.product_name,
        sales.order_date,
        RANK() OVER (PARTITION BY sales.customer_id ORDER BY sales.order_date) AS rank
    FROM dannys_diner.sales 
    LEFT JOIN dannys_diner.menu menu
    ON sales.product_id = menu.product_id
) ranked_data
WHERE rank = 1;
-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT  
  menu.product_name,
  COUNT(menu.product_name) AS num_compras
FROM dannys_diner.sales
LEFT JOIN dannys_diner.menu menu
ON sales.product_id = menu.product_id
GROUP BY menu.product_name
LIMIT 1

-- 5. Which item was the most popular for each customer?
SELECT customer_id, product_name, num_compras
FROM (
    SELECT
          sales.customer_id,
          menu.product_name,
          COUNT(menu.product_name) AS num_compras,
          RANK() OVER (PARTITION BY sales.customer_id ORDER BY COUNT(menu.product_name) DESC) AS rank
      FROM dannys_diner.sales 
      LEFT JOIN dannys_diner.menu menu
      ON sales.product_id = menu.product_id
  GROUP BY menu.product_name, sales.customer_id
) ranked_data
WHERE rank = 1;
-- 6. Which item was purchased first by the customer after they became a member?
WITH customer_first_orders AS (
  SELECT 
    s.customer_id, 
    s.order_date, 
    m.product_name,
    m.price,
    RANK() OVER (PARTITION BY s.customer_id ORDER BY s.order_date) AS rank
  FROM dannys_diner.sales s
  LEFT JOIN dannys_diner.menu m
  ON s.product_id = m.product_id
  LEFT JOIN dannys_diner.members mem
  ON s.customer_id = mem.customer_id
  WHERE mem.join_date IS NOT NULL AND s.order_date >= mem.join_date
)

SELECT customer_id, product_name
FROM customer_first_orders
WHERE rank = 1;



-- 7. Which item was purchased just before the customer became a member?
WITH customer_last_order AS (
  SELECT 
      s.customer_id,
      s.order_date,
      m.product_name,
      mem.join_date,
      RANK() OVER (PARTITION BY s.customer_id ORDER BY s.order_date DESC) AS rank
  FROM dannys_diner.sales s
    LEFT JOIN dannys_diner.menu m
    ON s.product_id = m.product_id
    LEFT JOIN dannys_diner.members mem
    ON s.customer_id = mem.customer_id
  WHERE s.order_date < mem.join_date
  )
  
  SELECT
  	customer_id, product_name
  FROM customer_last_order
  WHERE rank = 1



-- 8. What is the total items and amount spent for each member before they became a member?
-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?
-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

