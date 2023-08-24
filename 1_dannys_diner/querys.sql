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
SELECT 
     s.customer_id,
     m.product_name,
     m.price
 FROM dannys_diner.sales s
    LEFT JOIN dannys_diner.menu m
    ON s.product_id = m.product_id
    LEFT JOIN dannys_diner.members mem
    ON s.customer_id = mem.customer_id
  WHERE s.order_date < mem.join_date)
  
  SELECT
  	customer_id,
    COUNT(product_name) AS total_compras,
 	SUM(price) AS receita_total
 FROM itens
 GROUP BY customer_id

-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

WITH points AS(
SELECT 
     s.customer_id,
     m.product_name,
     SUM(CASE WHEN m.product_name <> 'sushi' THEN (m.price * 10) 
              ELSE (m.price * 20) END) AS points
 FROM dannys_diner.sales s
    LEFT JOIN dannys_diner.menu m
    ON s.product_id = m.product_id
    LEFT JOIN dannys_diner.members mem
    ON s.customer_id = mem.customer_id
  GROUP BY m.product_name, s.customer_id
  ORDER BY s.customer_id)
  
  SELECT
  	customer_id,
    SUM(points)
 FROM points
 GROUP BY customer_id

-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?

-- situação 1

WITH pre_assinatura AS
(SELECT 
     s.customer_id,
     m.product_name,
     s.order_date,
     mem.join_date,
     SUM(CASE WHEN m.product_name <> 'sushi' THEN (m.price * 10) 
              ELSE (m.price * 20) END) AS points
 FROM dannys_diner.sales s
    LEFT JOIN dannys_diner.menu m
    ON s.product_id = m.product_id
    LEFT JOIN dannys_diner.members mem
    ON s.customer_id = mem.customer_id
WHERE s.order_date < mem.join_date
GROUP BY m.product_name, s.customer_id, s.order_date, mem.join_date
 ORDER BY s.customer_id)
 
 SELECT
  	customer_id,
    SUM(points) AS ponto_pre
 FROM pre_assinatura
 GROUP BY customer_id

 -- situação 2
WITH primeira_semana AS
(
    SELECT 
        s.customer_id,
        m.product_name,
        s.order_date,
        mem.join_date,
        SUM(CASE WHEN m.product_name <> 'sushi' THEN (m.price * 10 * 2) 
                 ELSE (m.price * 20 * 2) END) AS points
    FROM dannys_diner.sales s
    LEFT JOIN dannys_diner.menu m
    ON s.product_id = m.product_id
    LEFT JOIN dannys_diner.members mem
    ON s.customer_id = mem.customer_id
    WHERE s.order_date >= mem.join_date 
      AND s.order_date <= mem.join_date + INTERVAL '6 DAY'
    GROUP BY m.product_name, s.customer_id, s.order_date, mem.join_date
)
 
SELECT
    customer_id,
    SUM(points) AS points
FROM primeira_semana
GROUP BY customer_id;

-- situação 3

SELECT 
        s.customer_id,
        SUM(CASE WHEN m.product_name <> 'sushi' THEN (m.price * 10) 
                 ELSE (m.price * 20) END) AS points
    FROM dannys_diner.sales s
    LEFT JOIN dannys_diner.menu m
        ON s.product_id = m.product_id
    LEFT JOIN dannys_diner.members mem
        ON s.customer_id = mem.customer_id
    WHERE s.order_date >= mem.join_date 
      AND s.order_date > mem.join_date + INTERVAL '6 DAY'
      AND EXTRACT(MONTH FROM s.order_date) = 1 
    GROUP BY s.customer_id

    -- união das situções em uma unica tabela

    WITH pre_assinatura AS
(
    SELECT 
        s.customer_id,
        m.product_name,
        s.order_date,
        mem.join_date,
        SUM(CASE WHEN m.product_name <> 'sushi' THEN (m.price * 10) 
                 ELSE (m.price * 20) END) AS points
    FROM dannys_diner.sales s
    LEFT JOIN dannys_diner.menu m
        ON s.product_id = m.product_id
    LEFT JOIN dannys_diner.members mem
        ON s.customer_id = mem.customer_id
    WHERE s.order_date < mem.join_date
    GROUP BY m.product_name, s.customer_id, s.order_date, mem.join_date
    ORDER BY s.customer_id
),
primeira_semana AS
(
     SELECT 
        s.customer_id,
        m.product_name,
        s.order_date,
        mem.join_date,
        SUM(CASE WHEN m.product_name <> 'sushi' THEN (m.price * 10* 2) 
                 ELSE (m.price * 20 * 2) END) AS points
    FROM dannys_diner.sales s
    LEFT JOIN dannys_diner.menu m
    ON s.product_id = m.product_id
    LEFT JOIN dannys_diner.members mem
    ON s.customer_id = mem.customer_id
    WHERE s.order_date >= mem.join_date 
      AND s.order_date <= mem.join_date + INTERVAL '6 DAY'
    GROUP BY m.product_name, s.customer_id, s.order_date, mem.join_date
    ORDER BY s.customer_id
),
restante_do_mes AS
(
    SELECT 
        s.customer_id,
        m.product_name,
        s.order_date,
        mem.join_date,
        SUM(CASE WHEN m.product_name <> 'sushi' THEN (m.price * 10) 
                 ELSE (m.price * 20) END) AS points
    FROM dannys_diner.sales s
    LEFT JOIN dannys_diner.menu m
        ON s.product_id = m.product_id
    LEFT JOIN dannys_diner.members mem
        ON s.customer_id = mem.customer_id
    WHERE s.order_date >= mem.join_date 
      AND s.order_date > mem.join_date + INTERVAL '6 DAY'
      AND EXTRACT(MONTH FROM s.order_date) = 1 
    GROUP BY m.product_name, s.customer_id, s.order_date, mem.join_date
)
 
SELECT customer_id, SUM(points) AS ponto_total
FROM (
    SELECT * FROM pre_assinatura
    UNION ALL
    SELECT * FROM primeira_semana
    UNION ALL
    SELECT * FROM restante_do_mes
) AS total_points
GROUP BY customer_id;

