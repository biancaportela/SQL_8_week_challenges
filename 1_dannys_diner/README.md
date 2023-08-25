# 🍜  Danny's Diner
<p align="center">
<img src="https://8weeksqlchallenge.com/images/case-study-designs/1.png" alt="header" width="350" height="350">


- O case original pode ser encontrado [aqui](https://8weeksqlchallenge.com/case-study-1/).

## 📚 Sumário
- [Introdução](#Introdução)
- [O problema](#o-problema)
- [Dados](#dados)
- [Soluções](#case-study-questions)


## 📖 Introdução

Neste repositório, acompanhamos a jornada de Danny, um apaixonado por comida japonesa, que abriu um charmoso restaurante no início de 2021, servindo seus pratos favoritos: sushi, curry e ramen.


## 📖 O problema

O restaurante, chamado "Diner's Danny", busca ajuda para transformar os dados coletados durante seus primeiros meses de operação em insights úteis. O objetivo é responder perguntas simples sobre os clientes, como padrões de visita, gastos e pratos favoritos. Isso permitirá uma conexão mais profunda com os clientes, resultando em experiências personalizadas e aprimoradas.

Danny também planeja usar esses insights para tomar decisões, como expandir o programa de fidelidade. Além disso, ele precisa criar conjuntos de dados simples para sua equipe analisar, sem a necessidade de conhecimento em SQL.

## 📖 Dados

O repositório contém três conjuntos de dados cruciais:

- `vendas (sales)`
- `menu`
- `membros (members)`

Você pode inspecionar o diagrama de relacionamento de entidades e os dados de exemplo abaixo.
<p align="center">
<img src="https://github.com/biancaportela/SQL_8_week_challenges/blob/main/imagens/schema_dannys_dinner.png?raw=true" alt="schema" >





Uma amostra de dados dos clientes foi disponibilizada por questões de privacidade, esperando que você desenvolva consultas SQL funcionais para responder às perguntas de Danny. 

Mais detalhes sobre as tabelas utilizadas:


<details>
  <summary>sales</summary>

A tabela de vendas (`sales`) registra todas as compras ao nível do `customer_id` com informações correspondentes de `order_date` e `product_id`, indicando quando e quais itens do menu foram pedidos.

| customer_id | order_date | product_id |
|-------------|------------|------------|
| A           | 2021-01-01 | 1          |
| A           | 2021-01-01 | 2          |
| A           | 2021-01-07 | 2          |
| A           | 2021-01-10 | 3          |
| A           | 2021-01-11 | 3          |
| A           | 2021-01-11 | 3          |
| B           | 2021-01-01 | 2          |
| B           | 2021-01-02 | 2          |
| B           | 2021-01-04 | 1          |
| B           | 2021-01-11 | 1          |
| B           | 2021-01-16 | 3          |
| B           | 2021-02-01 | 3          |
| C           | 2021-01-01 | 3          |
| C           | 2021-01-01 | 3          |
| C           | 2021-01-07 | 3          |    

</details>


<details>
  <summary>menu</summary>

A tabela de menu faz a correspondência do `product_id` com o nome real do produto (`product_name`) e o preço (`price`) de cada item do menu.

| product_id | product_name | price |
|------------|--------------|-------|
| 1          | sushi        | 10    |
| 2          | curry        | 15    |
| 3          | ramen        | 12    |

</details>


<details>
  <summary>members</summary>

A tabela final de membros registra a data de adesão (`join_date`) quando um `customer_id` ingressou na versão beta do programa de fidelidade do Diner do Danny.

| customer_id | join_date  |
|-------------|------------|
| A           | 2021-01-07 |
| B           | 2021-01-09 |

</details>


## 🚀 Case Study Questions

**1. Qual é o valor total que cada cliente gastou no restaurante?**

```sql
SELECT 
  sales.customer_id, 
  SUM(menu.price) AS total_amount
FROM dannys_diner.sales sales
LEFT JOIN dannys_diner.menu menu
ON sales.product_id = menu.product_id
GROUP BY sales.customer_id
ORDER BY total_amount DESC;

```
**Resposta**
| customer_id | total_amount |
|-------------|--------------|
| A           | 76           |
| B           | 74           |
| C           | 36           |

Os passos utilizados foram:
- Selecionei `sales.customer_id` e `SUM(menu.price) `para obter o valor total gasto por cliente.

- Usei **LEFT JOIN** para combinar dados das tabelas `sales` e `menu` usando `product_id`.

- Utilizei **GROUP BY** com `customer_id` para calcular a soma por cliente.

- Ordenei os resultados pelo valor total em ordem decrescente usando **ORDER BY** `total_amount` em ordem do cliente que mais comprou para o que menos comprou.

---
**2. Quantos dias cada cliente visitou o restaurante?**

```sql
SELECT 
	sales.customer_id,
    COUNT(sales.order_date) AS dias_visitados
FROM dannys_diner.sales 
GROUP BY sales.customer_id
ORDER BY sales.customer_id
```
| customer_id | dias_visitados |
|-------------|----------------|
| A           | 6              |
| B           | 6              |
| C           | 3              |

Os passos feitos foram:
- Usei a função de agregação **COUNT** para contar as entradas de cada cliente na tabela de vendas.
- Agrupei os resultados pelo ID do cliente (`customer_id`) e ordenei-os em ordem alfabética para melhor leitura dos dados.
---

**3. Qual foi o primeiro item do menu comprado por cada cliente?**

Minha primeira solução foi essa: 
```sql
SELECT
    DISTINCT sales.customer_id,
    FIRST_VALUE(menu.product_name) OVER (PARTITION BY sales.customer_id ORDER BY sales.order_date) b
FROM dannys_diner.sales 
LEFT JOIN dannys_diner.menu menu
ON sales.product_id = menu.product_id
```
| customer_id | primeiro_item    |
|-------------|-------|
| A           | curry |
| B           | curry |
| C           | ramen |

Os passos foram:
- A consulta começa selecionando distintamente (sem duplicatas) os IDs dos clientes da tabela de vendas (`sales.customer_id`).

- Em seguida, usei a função de janela **FIRST_VALUE** em conjunto com a cláusula **OVER** para calcular, para cada cliente, o primeiro item do menu que eles compraram, ordenado por data de pedido (`sales.order_date`), enquanto realizo um **LEFT JOIN** entre as tabelas de vendas e de menu usando o `product_id` correspondente.

Na possibilidade de que um cliente tenha comprando dois itens na sua primeira compra utilizei outra window function

```sql
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
```

| customer_id | product_name | order_date               |
| ----------- | ------------ | ------------------------ |
| A           | curry        | 2021-01-01T00:00:00.000Z |
| A           | sushi        | 2021-01-01T00:00:00.000Z |
| B           | curry        | 2021-01-01T00:00:00.000Z |
| C           | ramen        | 2021-01-01T00:00:00.000Z |
| C           | ramen        | 2021-01-01T00:00:00.000Z |




Os passos foram:

- Comecei o código selecionando a coluna `customer_id` e `product_name` de uma subconsulta.
- Na subconsulta interna, usei a função de janela **RANK()** para atribuir um rank a cada combinação de `customer_id` e `product_name` com base na data de pedido.
- A cláusula **PARTITION BY** `sales.customer_id` garante que o ranking seja reiniciado para cada cliente.
- A consulta externa seleciona apenas as linhas da subconsulta interna onde o rank é igual a 1, ou seja, os primeiros itens de cada cliente.
- Aqui vemos que a primeira compra de A foi um curry e um sushi e a primeira compra de C foram 2 ramens.
---

**4. Qual é o item mais comprado no menu e quantas vezes foi comprado por todos os clientes?**
```sql
SELECT  
  menu.product_name,
  COUNT(menu.product_name) AS num_compras
FROM dannys_diner.sales
LEFT JOIN dannys_diner.menu menu
ON sales.product_id = menu.product_id
GROUP BY menu.product_name
LIMIT 1
```
| product_name | num_compras |
|--------------|-------------|
| ramen        | 8           |

Os passos foram:

- Selecionei o nome do produto da tabela `menu` e utilizei **COUNT** para contar quantas vezes cada produto foi comprado, renomeando a contagem como `num_compras`.

- Combinei os dados das tabelas `sales` e `menu` com base na coluna `product_id`.

- Agrupei os resultados pelo nome do produto.

- Utilizei a função **LIMIT** para retornar apenas um resultado, representando o produto mais frequentemente comprado.
---

**5. Qual item foi o mais popular para cada cliente?**
```sql
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
```
| customer_id | product_name | num_compras |
|-------------|--------------|-------------|
| A           | ramen        | 3           |
| B           | curry        | 2           |
| B           | sushi        | 2           |
| B           | ramen        | 2           |
| C           | ramen        | 3           |

Podemos ver na tabela que os clientes podem ter mais de uma refeição favorita. B, por exemplo,parece desfrutar de todos os itens do menu.

Essa questão foi respondida de maneira similar à questão 3, utilizando uma função de janela. Os passos foram:

- Calculei o número de compras de cada produto (`num_compras`) para cada cliente (`customer_id`).
- Usei a função de janela **RANK()** para classificar as compras de cada cliente com base na contagem de produtos. 
- A cláusula **PARTITION BY** divide os dados por cliente, a cláusula **ORDER BY** define a ordenação.
- Ou seja: usei a função de classificação (**RANK**) para atribuir um ranking com base no número de compras de cada produto por cliente.
- Filtrai a subconsulta usando **WHERE** `rank = 1` para selecionar apenas os produtos mais comprados por cada cliente.

---

**6. Qual item foi comprado primeiro pelo cliente após ele se tornar membro?**

```sql
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
```
| customer_id | product_name |
|-------------|--------------|
| A           | curry        |
| B           | sushi        |

Os passos foram:

- Usei uma expressão de tabela comum (Common Table Expression - CTE) chamada `customer_first_orders` para organizar a lógica da consulta interna.

- Uni as tabelas `sales`, `menu` e `members` usando cláusulas LEFT JOIN.

- A CTE seleciona informações sobre o primeiro pedido feito por cada cliente no restaurante utilizando uma função de janela.

- Os pedidos são classificados por data de pedido para cada cliente e atribui um ranking.

- A consulta final seleciona o `customer_id`, `product_name` e `price` da CTE onde o ranking é igual a 1, ou seja, o primeiro pedido de cada cliente após se tornarem membros.
---

**7. Qual item foi comprado logo antes de o cliente se tornar membro?**
```sql
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
```

Esse resultado foi obtido de maneira similar ao da questão 6,mas aqui invertemos o sinal para termos os últimos pedidos antes do cliente se tornar membro do clube de assinaturas.
 
Os passos foram:

- O código utiliza uma Expressão de Tabela Comum (CTE) chamada `customer_last_order` para obter informações sobre o último pedido feito por cada cliente antes de se tornarem membros.

- Na CTE, uni a `tabela dannys_diner.sales` com as `tabelas dannys_diner.menu` e `dannys_diner.members` com base nos IDs dos clientes e dos produtos, e filtrei os registros em que a data do pedido é anterior à data de adesão do cliente.

- A função de janela **RANK()** é aplicada dentro da CTE para atribuir uma classificação a cada linha dentro de uma partição de IDs de clientes, ordenada pela data do pedido em ordem decrescente.

- A declaração final do SELECT recupera o ID do cliente e o nome do produto para as linhas na CTE `customer_last_order` em que a classificação é igual a 1. Isso corresponde ao último pedido feito por cada cliente antes de se tornarem membros do restaurante.
---

**8. Qual é o total de itens e valor gasto para cada membro antes de se tornarem membros?**
```sql
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
```

| customer_id | total_compras | receita_total |
|-------------|---------------|---------------|
| B           | 3             | 40            |
| A           | 2             | 25            |


Ainda trabalhando com CTE e com dados antes dos cliente virarem membros temos que:

- No primeiro trecho de código selecionei informações de vendas, incluindo o ID do cliente, o nome do produto e o preço do menu e separei as partições pelo cliente.

- Realizei uma junção das tabelas de vendas, menu e membros com base nas correspondentes IDs de cliente e IDs de produto e impus a condição para selecionar apenas as vendas que ocorreram antes de um cliente se tornar membro.

- O segundo trecho de código utiliza o resultado da primeira consulta (alias "itens") para calcular o total de compras (quantidade de produtos comprados) e a receita total (soma dos preços dos produtos) para cada cliente.

- Com a CTE feita utilizei a função **COUNT** para contar os produtos e assim saber quantos produtos foram pedidos para cada cliente. Em  seguinda utilizei a função **SUM** para saber a quantidade gasta por cada cliente.

---

**9. Se cada $1 gasto equivale a 10 pontos e o sushi tem um multiplicador de pontos de 2x - quantos pontos cada cliente teria?**
```sql
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
```
customer_id | sum
------------|-----
A           | 860
B           | 940
C           | 360

Os passos foram:

- Novamente, utilizei uma estrutura de **CTE** que nomeei de "points" para calcular a pontuação total acumulada por cada cliente com base nas compras realizadas.
- Selecionei o `customer_id` e o `product_name` da tabela de vendas e fiz um cálculo condicional usando uma cláusula **CASE**. Dependendo do nome do produto, a pontuação é multiplicada por 10 ou 20.

- As tabelas de vendas, menu e membros são unidas usando as cláusulas **LEFT JOIN** para obter informações sobre os produtos comprados, seus preços e os membros associados aos clientes.
O resultado é agrupado por `customer_id` e `product_name` e, em seguida, ordenado pelo `customer_id`. A soma das pontuações para cada cliente é calculada na subconsulta.

- Finalmente, a segunda consulta é executada no CTE `points`, agrupando os resultados novamente pelo `customer_id` e somando as pontuações acumuladas para cada cliente, resultando na pontuação total de pontos acumulada por cliente.
---

**10. Na primeira semana após um cliente aderir ao programa (incluindo a data de adesão), eles ganham 2x pontos em todos os itens, não apenas no sushi - quantos pontos os clientes A e B têm no final de janeiro?**

- Nesse caso temos 3 cenários diferentes. Para cada cenário eu fiz uma tabela temporária e a resposta final foi dada com a união das CTEs.

- Nessa questão foram trabalhadas as funções de **DATE**, em particular a  **INTERVAL** que permitiu delimitar a primeira semana pós adesão do clube de membros e a **EXTRACT** que permitiu extrais apenas os dados referentes a janeiro.

- Além disso, utilizei a função **UNION** para unir as CTEs.

### Situação 1: Antes de ser membro

**Hipóteses:**

- cada $1 gasto equivale a 10 pontos 

- o sushi tem um multiplicador de pontos de 2x

```sql
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
```

customer_id | ponto_pre
----------- | ---------
A           | 350
B           | 500

### Situação 2: Primeira semana como membro

**Hipóteses**

- Cada $1 gasto normalmente equivale a 10 pontos. No entanto, quando um cliente adere ao programa e durante a primeira semana após a adesão (incluindo a data de adesão), todos os itens, incluindo o sushi, recebem um multiplicador de pontos de 2x. 
- O sushi, durante a primeira semana de adesão, terá um multiplicador de pontos de 4x em vez de 2x, como os outros itens.

```sql
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
```
customer_id | points
----------- | ------
B           | 400
A           | 1020


### Situação 3: Restante do mês de janeiro
**Hipótese**

- Agora devemos calcular o restante do mês de janeiro, onde as condições de pontuação volta a ser as iniciais.


```sql
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


```
customer_id | points
----------- | ------
B           | 120

### Resultado final
**Hipótese**

- Juntando as 3 situações para ter o total de pontos dos membros ao final do mês de janeiro.

```sql
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
```

customer_id | ponto_total
------------|-------------
A           | 1370
B           | 1020


# Questões Bônus 

## Junte todas as coisas

Recrie a tabela com: `customer_id`, `order_date`, `product_name`, `price`, `member (Y/N)`


```sql
SELECT 
	s.customer_id,
    m.product_name,
    m.price,
    CASE WHEN mem.join_date <= s.order_date  THEN 'Y'
    ELSE 'N' END AS is_member
FROM dannys_diner.sales s
LEFT JOIN  dannys_diner.menu m
ON s.product_id = m.product_id
LEFT JOIN dannys_diner.members mem
ON s.customer_id = mem.customer_id
ORDER BY customer_id, order_date ASC
```

| customer_id | product_name | price | is_member |
|-------------|--------------|-------|-----------|
| A           | sushi        | 10    | N         |
| A           | curry        | 15    | N         |
| A           | curry        | 15    | Y         |
| A           | ramen        | 12    | Y         |
| A           | ramen        | 12    | Y         |
| A           | ramen        | 12    | Y         |
| B           | curry        | 15    | N         |
| B           | curry        | 15    | N         |
| B           | sushi        | 10    | N         |
| B           | sushi        | 10    | Y         |
| B           | ramen        | 12    | Y         |
| B           | ramen        | 12    | Y         |
| C           | ramen        | 12    | N         |
| C           | ramen        | 12    | N         |
| C           | ramen        | 12    | N         |




## Ranqueie todas as coisas

Danny também precisa de mais informações sobre a classificação dos produtos dos clientes, mas ele não precisa intencionalmente da classificação para compras de não membros, portanto, ele espera valores de classificação nulos para os registros quando os clientes ainda não fazem parte do programa de fidelidade.

```sql
WITH tab_completa AS (
SELECT 
	s.customer_id,
  	s.order_date,
    m.product_name,
    m.price,
    CASE WHEN mem.join_date <= s.order_date  THEN 'Y'
    ELSE 'N' END AS is_member
FROM dannys_diner.sales s
LEFT JOIN  dannys_diner.menu m
ON s.product_id = m.product_id
LEFT JOIN dannys_diner.members mem
ON s.customer_id = mem.customer_id
ORDER BY customer_id, order_date ASC

)

SELECT *,
	CASE WHEN is_member = 'N' THEN null
    ELSE RANK() OVER (PARTITION BY customer_id, is_member ORDER BY order_date ASC)
    END AS rank
FROM tab_completa
```

| customer_id | order_date            | product_name | price | is_member | rank |
|-------------|-----------------------|--------------|-------|-----------|------|
| A           | 2021-01-01T00:00:00.000Z | sushi        | 10    | N         | null |
| A           | 2021-01-01T00:00:00.000Z | curry        | 15    | N         | null |
| A           | 2021-01-07T00:00:00.000Z | curry        | 15    | Y         | 1    |
| A           | 2021-01-10T00:00:00.000Z | ramen        | 12    | Y         | 2    |
| A           | 2021-01-11T00:00:00.000Z | ramen        | 12    | Y         | 3    |
| A           | 2021-01-11T00:00:00.000Z | ramen        | 12    | Y         | 3    |
| B           | 2021-01-01T00:00:00.000Z | curry        | 15    | N         | null |
| B           | 2021-01-02T00:00:00.000Z | curry        | 15    | N         | null |
| B           | 2021-01-04T00:00:00.000Z | sushi        | 10    | N         | null |
| B           | 2021-01-11T00:00:00.000Z | sushi        | 10    | Y         | 1    |
| B           | 2021-01-16T00:00:00.000Z | ramen        | 12    | Y         | 2    |
| B           | 2021-02-01T00:00:00.000Z | ramen        | 12    | Y         | 3    |
| C           | 2021-01-01T00:00:00.000Z | ramen        | 12    | N         | null |
| C           | 2021-01-01T00:00:00.000Z | ramen        | 12    | N         | null |
| C           | 2021-01-07T00:00:00.000Z | ramen        | 12    | N         | null |
