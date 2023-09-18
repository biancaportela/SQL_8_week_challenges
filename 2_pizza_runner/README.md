# 🍕  Pizza Runner
<p align="center">
<img src="https://8weeksqlchallenge.com/images/case-study-designs/2.png" alt="header" width="350" height="350">


- O case original pode ser encontrado [aqui](https://8weeksqlchallenge.com/case-study-2/).

# 📚 Sumário
- [Introdução](#introdução)
- [O problema](#o-problema)
- [Dados](#dados)
- [Soluções](#case-study-questions)
    - [Data Preprocessing](#data-preprocessing)
    - [Métricas das pizzas](#métricas-das-pizzas)
    - [Experiência do usuário e do entregador](#experiência-do-usuário-e-do-entregador)
    - [Otimização dos igredientes utilizados](#otimização-dos-igredientes-utilizados)
    - [Precificação e avaliações](#precificação-e-avaliações)
    - [Perguntas adicionais](#perguntas-adicionais)

# Introdução
Com o objetivo de expandir sua pizzaria, Danny adotou uma abordagem inovadora ao lançar o Pizza Runner. Nesse empreendimento, ele recrutou uma equipe de entregadores para levar pizzas frescas diretamente aos clientes e também contratou desenvolvedores para criar um aplicativo móvel, permitindo aos clientes fazerem seus pedidos de forma conveniente e eficiente.

# O problema

Devido à experiência de Danny como cientista de dados, ele estava bem ciente de que a coleta de dados seria fundamental para o crescimento de seu negócio.

Ele preparou para nós um diagrama de relacionamento de entidades do seu design de banco de dados, mas necessita de assistência adicional para limpar seus dados e aplicar alguns cálculos básicos, a fim de orientar melhor seus entregadores e otimizar as operações do Pizza Runner.

# Dados

Danny compartilhou 6 datasets para o estudo de caso, sendo eles

- `runners`, `customer_orders`, `runner_orders`, `pizza_names`, `pizza_recipes`, `pizza_toppings`

Você pode inspecionar o diagrama de relacionamento de entidades e os dados de exemplo abaixo.

<p align="center">
<img src="https://github.com/biancaportela/SQL_8_week_challenges/blob/main/imagens/schema_pizza.png?raw=true" alt="schema" >

<details>
  <summary>runners</summary>

A tabela `runners` mostra a data de registro para cada novo entregador.

| runner_id | registration_date |
|-----------|-------------------|
| 1         | 2021-01-01        |
| 2         | 2021-01-03        |
| 3         | 2021-01-08        |
| 4         | 2021-01-15        |

</details>

<details>
  <summary>customer_orders</summary>

- Os pedidos de pizza dos clientes são registrados na tabela `customer_orders`, com uma linha para cada pizza individual que faz parte do pedido.

- O `pizza_id` está relacionado ao tipo de pizza que foi solicitado, enquanto as `exclusions` são os valores de `ingredient_id` que devem ser removidos da pizza e os `extras` são os valores de `ingredient_id` que precisam ser adicionados à pizza.

- Observe que os clientes podem fazer pedidos de várias pizzas em um único pedido, com valores diferentes para exclusões e extras, mesmo que o tipo de pizza seja o mesmo!

- As colunas `exclusions` e `extras` precisarão ser limpas antes de serem utilizadas em suas consultas.

| order_id | customer_id | pizza_id | exclusions | extras | order_time          |
|----------|-------------|----------|------------|--------|--------------------|
| 1        | 101         | 1        |            |        | 2021-01-01 18:05:02|
| 2        | 101         | 1        |            |        | 2021-01-01 19:00:52|
| 3        | 102         | 1        |            |        | 2021-01-02 23:51:23|
| 3        | 102         | 2        | NaN        |        | 2021-01-02 23:51:23|
| 4        | 103         | 1        | 4          |        | 2021-01-04 13:23:46|
| 4        | 103         | 1        | 4          |        | 2021-01-04 13:23:46|
| 4        | 103         | 2        | 4          |        | 2021-01-04 13:23:46|
| 5        | 104         | 1        | null       | 1      | 2021-01-08 21:00:29|
| 6        | 101         | 2        | null       | null   | 2021-01-08 21:03:13|
| 7        | 105         | 2        | null       | 1      | 2021-01-08 21:20:29|
| 8        | 102         | 1        | null       | null   | 2021-01-09 23:54:33|
| 9        | 103         | 1        | 4          | 1, 5   | 2021-01-10 11:22:59|
| 10       | 104         | 1        | null       | null   | 2021-01-11 18:34:49|
| 10       | 104         | 1        | 2, 6       | 1, 4   | 2021-01-11 18:34:49|

</details>

<details>
  <summary>runner_orders</summary>

Após cada pedido ser recebido pelo sistema, ele é atribuído a um entregador. No entanto, nem todos os pedidos são completamente concluídos e podem ser cancelados pelo restaurante ou pelo cliente.

O `pickup_time` é o carimbo de data/hora em que o entregador chega à sede do Pizza Runner para pegar as pizzas recém-cozidas. Os campos `distance` (distância) e `duration` (duração) estão relacionados com o quão longe e por quanto tempo o entregador teve que viajar para entregar o pedido ao respectivo cliente.

Há algumas questões conhecidas de dados com esta tabela, portanto tenha cuidado ao usá-la em suas consultas - certifique-se de verificar os tipos de dados de cada coluna no esquema SQL!

| order_id | runner_id | pickup_time        | distance | duration | cancellation          |
|----------|-----------|--------------------|----------|----------|-----------------------|
| 1        | 1         | 2021-01-01 18:15:34| 20km     | 32 minutes|                       |
| 2        | 1         | 2021-01-01 19:10:54| 20km     | 27 minutes|                       |
| 3        | 1         | 2021-01-03 00:12:37| 13.4km   | 20 mins  | NaN                   |
| 4        | 2         | 2021-01-04 13:53:03| 23.4km   | 40 mins  | NaN                   |
| 5        | 3         | 2021-01-08 21:10:57| 10km     | 15 mins  | NaN                   |
| 6        | 3         | null               | null     | null     | Restaurant Cancellation|
| 7        | 2         | 2020-01-08 21:30:45| 25km     | 25 mins  | null                  |
| 8        | 2         | 2020-01-10 00:15:02| 23.4 km  | 15 mins  | null                  |
| 9        | 2         | null               | null     | null     | Customer Cancellation |
| 10       | 1         | 2020-01-11 18:50:20| 10km     | 10 mins  | null                  |




</details>

<details>
  <summary>pizza_names</summary>

No momento, o Pizza Runner tem apenas 2 pizzas disponíveis: Meat Lovers ou Vegetariana!

| pizza_id | pizza_name    |
|---------|---------------|
| 1       | Meat Lovers   |
| 2       | Vegetarian    |

</details>


<details>
  <summary>pizza_recipes</summary>

Cada `pizza_id` possui um conjunto padrão de ingredientes que são usados como parte da receita da pizza.

| pizza_id | toppings           |
|----------|-------------------|
| 1        | 1, 2, 3, 4, 5, 6, 8, 10 |
| 2        | 4, 6, 7, 9, 11, 12 |


</details>

<details>
  <summary>pizza_topping</summary>

Esta tabela contém todos os valores de nome de sabores juntamente com seus respectivos valores de ID de sabores.

| topping_id | topping_name   |
|------------|----------------|
| 1          | Bacon          |
| 2          | BBQ Sauce      |
| 3          | Beef           |
| 4          | Cheese         |
| 5          | Chicken        |
| 6          | Mushrooms      |
| 7          | Onions         |
| 8          | Pepperoni      |
| 9          | Peppers        |
| 10         | Salami         |
| 11         | Tomatoes       |
| 12         | Tomato Sauce   |




</details>

## Soluções

Este estudo de caso apresenta uma série de etapas interligadas.

A primeira delas está focada na limpeza e preparação dos dados. Posteriormente, são abordadas questões relacionadas às métricas das pizzas, experiência tanto do usuário quanto do entregador, otimização dos ingredientes, precificação e avaliações, além das perguntas adicionais.


## Data Preprocessing

Danny nos informou que alguma das tabelas precisam de uma limpeza prévias, antes de começar as análises.

Os problemas com as tabelas envolvem:

- Correção de dados faltantes: 
    -  os valores `null` estão imputados como texto.
    -  há tanto `null` quanto `NA` para indicar dados faltantes.

- As unidades de distância e de minutagem foram imputadas manualmente e precisam ser corrigidas.


### Tabela `customer_orders`

- Correção de dados faltantes: 
    -  os valores `null` estão imputados como texto.
    -  há tanto `null` quanto `NA` para indicar dados faltantes.

```sql
CREATE TEMP TABLE customer_orders_temp AS
  SELECT
      order_id,
      customer_id,
      pizza_id,
      CASE WHEN exclusions = 'null' THEN ''
      ELSE exclusions END AS exclusions,
      CASE WHEN extras = 'null' OR extras IS NULL THEN ''
      ELSE extras END AS extras,
      order_time
  FROM pizza_runner.customer_orders;

```

Os resultados da tabela limpos estão aqui:
<details>
  <summary>customer_orders_temp</summary>

| order_id | customer_id | pizza_id | exclusions | extras | order_time               |
|----------|-------------|----------|------------|--------|-------------------------|
| 1        | 101         | 1        |            |        | 2020-01-01T18:05:02.000Z|
| 2        | 101         | 1        |            |        | 2020-01-01T19:00:52.000Z|
| 3        | 102         | 1        |            |        | 2020-01-02T23:51:23.000Z|
| 3        | 102         | 2        |            |        | 2020-01-02T23:51:23.000Z|
| 4        | 103         | 1        | 4          |        | 2020-01-04T13:23:46.000Z|
| 4        | 103         | 1        | 4          |        | 2020-01-04T13:23:46.000Z|
| 4        | 103         | 2        | 4          |        | 2020-01-04T13:23:46.000Z|
| 5        | 104         | 1        |            | 1      | 2020-01-08T21:00:29.000Z|
| 6        | 101         | 2        |            |        | 2020-01-08T21:03:13.000Z|
| 7        | 105         | 2        |            | 1      | 2020-01-08T21:20:29.000Z|
| 8        | 102         | 1        |            |        | 2020-01-09T23:54:33.000Z|
| 9        | 103         | 1        | 4          | 1, 5   | 2020-01-10T11:22:59.000Z|
| 10       | 104         | 1        |            |        | 2020-01-11T18:34:49.000Z|
| 10       | 104         | 1        | 2, 6       | 1, 4   | 2020-01-11T18:34:49.000Z|

</details>

**Passos:**

- Criação de Tabela Temporária: Foi criada uma tabela temporária chamada `customer_orders_temp` para armazenar dados tratados.
- Seleção de Colunas Relevantes: A consulta seleciona colunas importantes, incluindo `order_id`, `customer_id`, `pizza_id` e `order_time`.
- Tratamento de Dados: Através da cláusula **CASE**, os valores 'null' nas colunas exclusions e extras são substituídos por strings vazias.

### Tabela `runner_orders`

- Correção de dados faltantes: 
    -  os valores `null` estão imputados como texto.
    -  há tanto `null` quanto `NA` para indicar dados faltantes.
- Correção das medidas de unidade:
    - remover os 'km' e tranformar em um coluna com apenas números em `distance`
    - remover os textos sinalizando a hora e transformar em uma coluna com apenas números em `duration`

```sql
CREATE TEMP TABLE runner_orders_temp AS
SELECT
     order_id,
     runner_id,
     --- pickup_time
     CASE
     	WHEN pickup_time = 'null' THEN ' '
        ELSE pickup_time
     END AS pickup_time,
     -- colunas distance 
     CASE 
         WHEN distance LIKE '%km' THEN TRIM(TRAILING 'km' FROM distance)
         WHEN distance = 'null' THEN ' '
         ELSE distance
     END AS distance,
     -- coluna duration
     CASE
     	WHEN duration LIKE '%minutes' THEN TRIM(TRAILING 'minutes' FROM  duration)
        WHEN duration LIKE '%mins' THEN TRIM(TRAILING 'mins' FROM  duration)
        WHEN duration LIKE '%minute' THEN TRIM(TRAILING 'minute' FROM  duration)
        WHEN duration = 'null' THEN ' '
     	ELSE duration
     END AS duration,
     --- coluna cancellation
     CASE
     	WHEN cancellation = 'null' OR cancellation IS NULL THEN ' '
        ELSE cancellation
     END AS cancellation
FROM pizza_runner.runner_orders;
```

Os resultados da tabela limpos estão aqui:
<details>
  <summary>runner_orders_temp</summary>

| order_id | runner_id | pickup_time        | distance | duration | cancellation          |
|----------|-----------|-------------------|----------|----------|-----------------------|
| 1        | 1         | 2020-01-01 18:15:34 | 20       | 32       |                       |
| 2        | 1         | 2020-01-01 19:10:54 | 20       | 27       |                       |
| 3        | 1         | 2020-01-03 00:12:37 | 13.4     | 20       |                       |
| 4        | 2         | 2020-01-04 13:53:03 | 23.4     | 40       |                       |
| 5        | 3         | 2020-01-08 21:10:57 | 10       | 15       |                       |
| 6        | 3         |                   |          |          | Restaurant Cancellation |
| 7        | 2         | 2020-01-08 21:30:45 | 25       | 25       |                       |
| 8        | 2         | 2020-01-10 00:15:02 | 23.4     | 15       |                       |
| 9        | 2         |                   |          |          | Customer Cancellation  |
| 10       | 1         | 2020-01-11 18:50:20 | 10       | 10       |                       |

</details>

**Passos:**

- Criação de Tabela Temporária: Uma tabela temporária chamada `runner_orders_temp` foi criada para armazenar os resultados da consulta a seguir.

- Seleção de Colunas e Tratamento de Nulos: A consulta seleciona as `colunas order_id`, `runner_id`, `pickup_time`, `distance`, `duration` e `cancellation` da tabela `pizza_runner.runner_orders`. Ela também aplica uma lógica de tratamento de nulos usando a cláusula **CASE** nas colunas `pickup_time`, `distance`, `duration` e `cancellation`.

- Tratamento de Valores Nulos e Unidades de Medida: utilização da função **TRIM** para remover unidades de medida específicas (como "km", "minutes", "mins" e "minute") de strings em colunas de dados, garantindo que os valores sejam formatados corretamente e também substituindo valores "null" por espaços vazios para melhorar a apresentação dos dados.

---

## Métricas das pizzas

**1. Quantas pizzas foram pedidas?**

```sql
SELECT
	COUNT (pizza_id) AS pedidos_total
FROM customer_orders_temp;
```
| pedidos_total |
|:-------------:|
|      14       |


**Passos:**

- A função **COUNT()** é usada para contar o número de registros que possuem valores não nulos na coluna `pizza_id`.

**2. Quantos pedidos  únicos foram feitos?**

```sql
SELECT
	COUNT(DISTINCT order_id) AS ordens_unicas
FROM customer_orders_temp
```
| ordens_unicas |
|--------------|
|      10      |

**Passos:**
- O código utiliza a função **COUNT()** para contar o número de ordens únicas na tabela `customer_orders_temp`.

- A cláusula **DISTINCT** é usada para garantir que apenas valores únicos de `order_id` sejam considerados ao contar as ordens únicas na tabela. 


**3. Quantos pedidos bem-sucedidos foram entregues por cada entregador?**

```sql
SELECT
  runner_id,	
  COUNT(order_id) pediddos_sucedidos
FROM runner_orders_temp
WHERE cancellation IS  NULL
	OR cancellation NOT IN ('Restaurant Cancellation', 'Customer Cancellation')
GROUP BY runner_id
ORDER BY runner_id 
```

| runner_id | pediddos_sucedido |
|-----------|-------------------|
| 1         | 4                 |
| 2         | 3                 |
| 3         | 1                 |

**Passos:**

- A consulta conta o número de pedidos (`order_id`) para cada entregador (`runner_id`), mas apenas para aqueles pedidos que não foram cancelados. 

- Isso é feito usando a cláusula **WHERE** que verifica se a coluna `cancellation` é nula ou não está nos valores de cancelamento ('Restaurant Cancellation' ou 'Customer Cancellation').

- Os resultados são agrupados por `runner_id` e, em seguida, a cláusula **ORDER BY** organiza os resultados em ordem crescente de `runner_id`.



**4. Quantos de cada tipo de pizza foram entregues?**

```sql
SELECT 
	pizza_name,
    COUNT(co.order_id) AS qtd_pizza_entregue
FROM customer_orders_temp AS co
LEFT JOIN pizza_runner.pizza_names AS pn
ON co.pizza_id = pn.pizza_id
LEFT JOIN  runner_orders_temp AS ro
ON co.order_id = ro.order_id
WHERE cancellation IS  NULL
	OR cancellation NOT IN ('Restaurant Cancellation', 'Customer Cancellation')
GROUP BY pizza_name
```

| pizza_name  | qtd_pizza_entregue |
|-------------|-------------------|
| Meatlovers  | 9                 |
| Vegetarian  | 3                 |

**Passos:**

- Seleção de Dados e Junções: Utilizando as tabelas `customer_orders_temp`, `pizza_names` e `runner_orders_temp`, selecionei as colunas necessárias para a análise e estabeleci as junções apropriadas com base nas colunas-chave como `pizza_id` e `order_id`.

- Filtragem de Pedidos Válidos: Utilizei a cláusula **WHERE** para filtrar os registros com base nas condições de cancelamento, como feito na questão anterior. 

- Agrupamento e Contagem: Usando a cláusula **GROUP BY**, agrupei os registros por `pizza_name`, que representa o nome de cada tipo de pizza. Em seguida, usei a função de agregação **COUNT** para contar quantos pedidos de cada tipo de pizza foram entregues.

**5. Quantas pizzas Vegetarianas e Meat Lovers foram pedidas por cada cliente?**


```sql
SELECT
    co.customer_id,
    SUM(CASE WHEN pn.pizza_name = 'Vegetarian' THEN 1 ELSE 0 END) AS qtd_vegetarian,
    SUM(CASE WHEN pn.pizza_name = 'Meatlovers' THEN 1 ELSE 0 END) AS qtd_meatlovers
FROM customer_orders_temp AS co
LEFT JOIN pizza_runner.pizza_names AS pn ON co.pizza_id = pn.pizza_id
GROUP BY co.customer_id
ORDER BY co.customer_id;
```
| customer_id | qtd_vegetarian | qtd_meatlovers |
|-------------|----------------|----------------|
| 101         | 1              | 2              |
| 102         | 1              | 2              |
| 103         | 1              | 3              |
| 104         | 0              | 3              |
| 105         | 1              | 0              |

**Passos:**
- Utiliza a função de agregação **SUM** junto com a expressão condicional **CASE** para calcular a quantidade de pizzas Vegetarianas e Meat Lovers para cada cliente. Se o nome da pizza for 'Vegetarian', a expressão **CASE** atribui o valor 1, caso contrário, atribui o valor 0. O **SUM** acumula esses valores para cada tipo de pizza.

- A cláusula LEFT JOIN é usada para combinar as informações da tabela `customer_orders_temp` com a `tabela pizza_names`, com base na coluna `pizza_id`.

- A cláusula **GROUP BY** agrupa os resultados pelo `customer_id`, ou seja, a quantidade de pizzas é calculada por cliente.

**6. Qual foi o número máximo de pizzas entregues em um único pedido?**

```sql
SELECT 
	ro.order_id,
	COUNT(ro.order_id) AS qtd
FROM customer_orders_temp AS co
LEFT JOIN  runner_orders_temp AS ro
ON co.order_id = ro.order_id
WHERE cancellation IS  NULL
	OR cancellation NOT IN ('Restaurant Cancellation', 'Customer Cancellation')
GROUP BY ro.order_id
ORDER BY qtd DESC
LIMIT 1
```
| order_id | qtd |
|----------|-----|
| 4        | 3   |

**Passos:**
- A consulta seleciona duas colunas, `order_id` da tabela `runner_orders_temp` e a contagem da coluna `order_id`, que é renomeada como `qtd` (quantidade).
- A tabela temporária `customer_orders_temp` é unida com as tabelas `runner_orders_temp` usando cláusulas **LEFT JOIN**. 
- Os resultados são filtrados para incluir apenas os pedidos que não foram cancelados. Isso é feito através da cláusula **WHERE**.
- Os resultados são agrupados pelo `order_id` usando a cláusula **GROUP BY**. Isso significa que as contagens são calculadas para cada pedido.
- Os resultados são ordenados em ordem decrescente de contagem (qtd) usando a cláusula **ORDER BY**.
- A cláusula **LIMIT** 1 é usada para restringir o resultado a apenas uma linha, que corresponde ao pedido com o maior número de pizzas entregues, conforme determinado pela contagem.

**7. Para cada cliente, quantas pizzas entregues tiveram pelo menos 1 alteração e quantas não tiveram alterações?**

```sql
SELECT 
  co.customer_id,
  SUM(CASE WHEN co.extras <> '' OR co.exclusions <> '' THEN 1 ELSE 0 END) AS alteração,
  SUM (CASE WHEN co.extras = '' AND co.exclusions = '' THEN 1 ELSE 0 END) AS sem_alteração
FROM customer_orders_temp AS co
LEFT JOIN  runner_orders_temp AS ro
ON co.order_id = ro.order_id
WHERE ro.cancellation IS NULL
  OR ro.cancellation NOT IN ('Restaurant Cancellation', 'Customer Cancellation')
GROUP BY co.customer_id
ORDER BY co.customer_id;

```

| customer_id | alteração | sem_alteração |
|------------|-----------|---------------|
| 101        | 0         | 2             |
| 102        | 0         | 3             |
| 103        | 3         | 0             |
| 104        | 2         | 1             |
| 105        | 1         | 0             |

**Passos:**
- Para esta etapa, empreguei a estrutura de tabela desenvolvida em questões anteriores, combinando os dados das tabelas temporárias `customer_orders_temp` e `runner_orders_temp`.

- Além disso, realizei uma seleção específica, focando exclusivamente nos pedidos entregues, por meio da cláusula **WHERE**.

- Uma inovação neste código reside na incorporação da cláusula **CASE**, em conjunto com a função **SUM**, que permite quantificar tanto os pedidos com modificações (quando há valores em "extras" ou "exclusions") quanto os pedidos sem alterações (quando ambos "extras" e "exclusions" estão vazios).

- Finaliza-se ao agrupar e ordenar os resultados com base no `customer_id`.


**8. Quantas pizzas foram entregues que tinham tanto exclusões quanto extras?**

```sql
SELECT 
SUM(CASE WHEN co.extras <> '' AND co.exclusions <> '' THEN 1 ELSE 0 END) AS alteração
FROM customer_orders_temp AS co
LEFT JOIN  runner_orders_temp AS ro
ON co.order_id = ro.order_id
WHERE ro.cancellation IS NULL
  OR ro.cancellation NOT IN ('Restaurant Cancellation', 'Customer Cancellation')
```

|alteração|
|---------|
|1        |

**Passos:**

- Utilizando a estrutura já previamente estabelecida, apenas alterei a estrutura lógica da cláusula **CASE**, e também eliminei o trecho de código que não se mostrava relevante (referente às pizzas sem modificações).

- Ao substituir-se a cláusula OR por AND, atende-se as condições lógicas da questão, resultando na obtenção do resultado esperado.

**9. Qual foi o volume total de pizzas encomendadas para cada hora do dia?**

```sql
SELECT 
	EXTRACT(HOUR FROM MAX(order_time)) AS hora,
    COUNT(order_id) as qtd_pedidos
FROM customer_orders_temp
GROUP BY EXTRACT(HOUR FROM order_time)
ORDER BY qtd_pedidos DESC,hora ASC;
```
hora   | qtd_pedidos
-------|------------
13     | 3
18     | 3
21     | 3
23     | 3
11     | 1
19     | 1

**Passos:**

- Selesionei a hora (apenas a parte da hora) da coluna `order_time` da tabela temporária `customer_orders_temp` usando a função **EXTRACT(HOUR FROM ...)**.

- Calculei a contagem total de pedidos para cada hora usando a função `COUNT(order_id)`.

- Os resultados são agrupados de acordo com a hora extraída da coluna `order_time`.

- Os resultados finais são ordenados em ordem decrescente de contagem de pedidos (`qtd_pedidos`) e, em caso de empate na contagem, são ordenados em ordem crescente de hora (`hora`).

**10. Qual foi o volume de pedidos para cada dia da semana?**

```sql
SELECT 
	to_char(order_time, 'Day') AS dia_da_semana,
    COUNT(order_id) as qtd_pedidos
FROM customer_orders_temp
GROUP BY to_char(order_time, 'Day') 
ORDER BY dia_da_semana ASC
```

| dia_da_semana | qtd_pedidos |
|---------------|-------------|
| Friday        | 1           |
| Saturday      | 5           |
| Thursday      | 3           |
| Wednesday     | 5           |

**Passos:**
- De maneira similar à questão anterior, extraímos o dia da semana da coluna `order_time` da tabela temporária `customer_orders_temp` usando a função **to_char(order_time, 'Day')**

- Calculei a contagem total de pedidos para cada dia da semana usando a função `COUNT(order_id)`.

- Os resultados são agrupados de acordo com o dia da semana extraída da coluna `order_time`.

- Os resultados finais são ordenados em ordem pelo dia da semana.

---


## Experiência do usuário e do entregador

**1. Quantos runners se inscreveram para cada período de 1 semana? (i.e, a semana começa em 2021-01-01)**

```sql
SELECT 
  DATE_PART('WEEK', registration_date) AS registration_week,
  COUNT(runner_id) AS runner_signup
FROM pizza_runner.runners
GROUP BY DATE_PART('WEEK', registration_date);
```

| registration_week | runner_signup |
|-------------------|---------------|
|        53         |       2       |
|         1         |       1       |
|         2         |       1       |

**Passos:**

- Nesse código utilizei a função **DATE_PART** para calcular o número da semana em que cada registro ocorreu. Isso é feito a partir da coluna `registration_date` na tabela `pizza_runner.runners`. O resultado é renomeado como `registration_week`.

- A segunda linha do código utiliza a função **COUNT** para contar o número de inscrições de corredores (`runner_id`) em cada semana. Isso é renomeado como `runner_signup`.

- Por fim, utilizei a cláusula **GROUP BY** para agrupar os resultados com base no número da semana calculado anteriormente. 

- Como resultado temos uma tabela que mostra o número da semana (`registration_week`) e o número de inscrições de corredores (`runner_signup`) em cada semana. 

- **OBS**:  Em relação ao número da semana 53, é importante observar que o PostgreSQL segue a convenção ISO 8601 para contar as semanas do ano. Nesse sistema, o ano começa na semana que inclui o dia 4 de janeiro. No ano de 2021, por exemplo, o dia 04/01 caiu na segunda semana do ano, quando contamos a partir do dia 01 de janeiro como o início do ano.

**2. Qual foi o tempo médio em minutos que cada runner levou para chegar à sede da Pizza Runner para pegar o pedido?**

```sql
WITH runner_pickup AS (
  SELECT 
    ro.runner_id,
    ro.order_id,
    co.order_time,
    CASE
      WHEN ro.pickup_time <> ' ' THEN TO_TIMESTAMP(ro.pickup_time, 'YYYY-MM-DD HH24:MI:SS')
      ELSE NULL
    END AS pickup_time_timestamp
  FROM customer_orders_temp co
  LEFT JOIN runner_orders_temp ro
  ON co.order_id = ro.order_id
)

SELECT
  runner_id,
  AVG(DATE_PART('minute', pickup_time_timestamp - order_time)) AS average_time_difference_minutes
FROM runner_pickup
GROUP BY runner_id;
```

| runner_id | average_time_difference_minutes |
|-----------|--------------------------------|
|     3     |             10.0               |
|     2     |             23.4               |
|     1     |        15.333333333333334      |


**Passos:**
- Comecei o código definindo uma Common Table Expression (CTE) chamada `runner_pickup`. Esta CTE é uma consulta temporária que combina dados de duas tabelas, `customer_orders_temp` e `runner_orders_temp`, usando uma operação de junção esquerda (**LEFT JOIN**). Ela seleciona várias colunas, incluindo `runner_id`, `order_id`, `order_time`, e calcula uma nova coluna chamada `pickup_time_timestamp`. Essa nova coluna é criada com base na coluna `pickup_time`, que é convertida para o tipo **TIMESTAMP** usando a função **TO_TIMESTAMP** se não for uma string vazia (' '), caso contrário, é definida como **NULL**.

- Na segunda parte do código executei uma consulta na CTE `runner_pickup`. Selecionei a coluna `runner_id` e calculei a média das diferenças em minutos entre as colunas `pickup_time_timestamp` e `order_time`. Fiz isso usando a função **DATE_PART** para calcular a diferença em minutos entre as duas colunas e a função **AVG** para calcular a média dessas diferenças. O resultado é retornado como uma coluna chamada `average_time_difference_minutes`.

- O resultado da consulta é agrupado pela coluna `runner_id` usando a cláusula GROUP BY. 

- A consulta final retorna a média das diferenças de tempo em minutos para cada `runner_id` presente nos dados.

**3. Existe alguma relação entre o número de pizzas e o tempo necessário para preparar o pedido?**

```sql

WITH pizza_preparation_stats AS (
  WITH runner_pickup AS (
    SELECT 
      ro.runner_id,
      ro.order_id,
      co.order_time,
      co.pizza_id,
      CASE
        WHEN ro.pickup_time <> ' ' THEN TO_TIMESTAMP(ro.pickup_time, 'YYYY-MM-DD HH24:MI:SS')
        ELSE NULL
      END AS pickup_time_timestamp
    FROM customer_orders_temp co
    LEFT JOIN runner_orders_temp ro ON co.order_id = ro.order_id
  )
  SELECT
    order_id,
    COUNT(pizza_id) AS number_of_pizzas,
    AVG(DATE_PART('minute', pickup_time_timestamp - order_time)) AS average_time_difference_minutes
  FROM
    runner_pickup
  GROUP BY
    order_id
  ORDER BY
    order_id
)

SELECT
  number_of_pizzas,
  AVG(average_time_difference_minutes) AS avg_time_difference
FROM
  pizza_preparation_stats
GROUP BY
  number_of_pizzas
ORDER BY
  number_of_pizzas;
```
| number_of_pizzas | avg_time_difference |
|------------------|---------------------|
| 1                | 12                  |
| 2                | 18                  |
| 3                | 29                  |


**Passos:**

Para fazer essa consulto foi necessário utilizar CTEs aninhadas (talvez não seja a solução mais elegante).

- **CTEs Aninhadas**: A primeira CTE, chamada `runner_pickup`, é definida dentro da segunda CTE chamada `pizza_preparation_stats`. Isso permite uma organização lógica das consultas, com a segunda CTE construindo sobre os resultados da primeira. A primeira CTE tem por objetivo separar o tempo de duração de cada pedido, enquanto a segunda tem por objetivo calcular o número de pizzas em cada pedido.

- **Cálculos de Estatísticas**: Assim, segunda CTE (`pizza_preparation_stats`) calcula estatísticas relacionadas à preparação de pizzas, como o número de pizzas em cada pedido e o tempo médio de preparação em minutos. Isso é feito com base nos dados das tabelas `customer_orders_temp` e `runner_orders_temp`.


- **Consulta de Resultados**: Finalmente, a consulta principal fora das CTEs usa a tabela temporária `pizza_preparation_stats` para calcular a média do tempo de diferença para diferentes números de pizzas em pedidos. Isso permite analisar a relação entre o número de pizzas em um pedido e o tempo médio de preparação. A consulta principal é organizada em torno dos resultados já calculados nas CTEs.


**4. Qual foi a distância média percorrida para cada cliente?**

```sql
SELECT 
  co.customer_id,
  AVG(CASE
    WHEN ro.distance <> ' ' THEN (ro.distance)::FLOAT
    ELSE NULL
  END) AS distance_avg
FROM
  runner_orders_temp ro
LEFT JOIN
  customer_orders_temp co
ON
  ro.order_id = co.order_id
GROUP BY customer_id
ORDER BY customer_id
```
| customer_id | distance_avg           |
|------------|------------------------|
| 101        | 20                     |
| 102        | 16.733333333333334     |
| 103        | 23.399999999999995     |
| 104        | 10                     |
| 105        | 25                     |


**Passos:**

- A consulta seleciona duas colunas da tabela, `customer_id` da tabela `customer_orders_temp` e a média dos valores da coluna `distance` após uma condição **CASE**. A função AVG é usada para calcular a média desses valores.

- A expressão **CASE** é usada para verificar se a coluna `distance` da tabela `runner_orders_temp` não é uma string vazia. Se a condição for verdadeira, o valor da coluna `distance` é convertido em um tipo de dado float, caso contrário, é atribuído o valor NULL. Isso garante que apenas valores não vazios e numéricos sejam incluídos no cálculo da média.

- Os resultados são agrupados pelo valor da coluna `customer_id`, o que significa que a média da coluna distance será calculada separadamente para cada cliente.

**5. Qual foi a diferença entre os tempos de entrega mais longos e mais curtos de todos os pedidos?**

```sql
SELECT MAX(duration::NUMERIC) - MIN(duration::NUMERIC) AS delivery_time_difference
FROM runner_orders_temp
where duration not like ' ';
```
| delivery_time_difference |
|-------------------------|
| 30                      |


**Passos:**
- Filtrei os dados na tabela `runner_orders_temp` usando a cláusula **WHERE** para selecionar apenas as linhas onde a coluna `duration` não é uma string vazia para evitar valores inválidos.

- Calculei a diferença entre o valor máximo (**MAX**) e o valor mínimo (**MIN**) da coluna `duration` após converter os valores para o tipo de dados **NUMERIC**. Isso resulta na diferença total de tempo entre os valores máximo e mínimo na coluna `duration`, que é nomeada como `delivery_time_difference`.

**6. Qual foi a velocidade média para cada runner em cada entrega, e você percebeu alguma tendência nesses valores?**

```sql
SELECT
ro.order_id,
ro.runner_id,
COUNT(pizza_id) AS num_pizza,
ROUND(AVG(ro.distance::NUMERIC / ro.duration::NUMERIC *60),2) AS avg_vel
FROM runner_orders_temp ro
LEFT JOIN customer_orders_temp co
ON ro.order_id = co.order_id
WHERE ro.distance <> ' '
GROUP BY ro.order_id, ro.runner_id
ORDER BY avg_vel
```
| order_id | runner_id | num_pizza | avg_vel |
|----------|-----------|-----------|---------|
| 4        | 2         | 3         | 35.10   |
| 1        | 1         | 1         | 37.50   |
| 5        | 3         | 1         | 40.00   |
| 3        | 1         | 2         | 40.20   |
| 2        | 1         | 1         | 44.44   |
| 10       | 1         | 2         | 60.00   |
| 7        | 2         | 1         | 60.00   |
| 8        | 2         | 1         | 93.60   |

- Não parece haver relação entre a velocidade de entrega e o número de entregas.


**Passos:**

- Selecionei as colunas `order_id` e `runner_id` da tabela `runner_orders_temp`. Também contei o número de pizzas em cada pedido usando **COUNT(pizza_id)** e calculei a média da velocidade usando a fórmula **(ro.distance::NUMERIC / ro.duration::NUMERIC * 60)** após converter a distância e a duração em minutos.

- Fiz a junção (**LEFT JOIN**) entre a tabela `runner_orders_temp` (representando os dados dos corredores) e a tabela `customer_orders_temp` (representando os dados dos clientes) com base no `order_id`. 

- A cláusula **WHERE** filtra os registros onde a coluna `distance` não é uma string vazia. Isso garante que apenas registros com informações válidas de distância sejam incluídos no cálculo da média de velocidade.

- Agrupei usando **GROUP BY** `ro.order_id`, `ro.runner_id`, o que significa que a média de velocidade é calculada separadamente para cada combinação única de order_id e runner_id. A cláusula **ORDER BY** avg_vel ordena os resultados com base na média de velocidade em ordem crescente.

**7. Qual é a porcentagem de entregas bem-sucedidas para cada runner?**

```sql
SELECT 
  runner_id, 
  ROUND(100 * SUM(
    CASE WHEN distance = ' ' THEN 0
    ELSE 1 END) / COUNT(*), 0) AS success_perc
FROM runner_orders_temp 
GROUP BY runner_id;
```
| runner_id | success_perc |
|-----------|--------------|
| 3         | 50           |
| 2         | 75           |
| 1         | 100          |

**Passos:**

A porcentagem de sucesso representa a proporção de pedidos entregues com sucesso em relação ao total de pedidos para cada runner. Para calulcar  a porcentagem de sucesso foi feito as seguintes operações:

- Contei os pedidos entregues com sucesso (onde a coluna `distance` não é uma string vazia) e dividi pelo número total de pedidos, multiplicando por 100.

- A função **ROUND** é usada para arredondar a porcentagem de sucesso para o número inteiro mais próximo, sem casas decimais.

- Agrupei os resultados por `runner_id`, garantindo que a porcentagem de sucesso seja calculada separadamente para cada corredor na tabela `runner_orders_temp`.



## Otimização dos igredientes utilizados

1. **Quais são os ingredientes padrão para cada pizza?**

```sql

```

2. **Qual foi o extra mais frequentemente adicionado?**


```sql

```

3. **Qual foi a exclusão mais comum?**


```sql

```

4. **Gerar uma nova tabela para cada registro na tabela `customers_orders` no seguinte formato:**

- Meat Lovers
- Meat Lovers - Exclude Beef
- Meat Lovers - Extra Bacon
- Meat Lovers - Exclude Cheese, Bacon - Extra Mushroom, Peppers


```sql

```

5. **Gerar uma lista de ingredientes separados por vírgula em ordem alfabética para cada pedido de pizza da tabela `customers_orders`.  Adicione um "2x" na frente de quaisquer ingredientes relevantes.**

- Ex:  "Meat Lovers: 2xBacon, Beef, ... , Salami"

```sql

```

6. **Qual é a quantidade total de cada ingrediente usado em todas as pizzas entregues, ordenado pela mais frequente primeiro lugar?**

```sql

```
---

## Precificação e avaliações

---

## Perguntas adicionais