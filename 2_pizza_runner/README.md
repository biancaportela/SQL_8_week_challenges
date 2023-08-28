# 🍕  Pizza Runner
<p align="center">
<img src="https://8weeksqlchallenge.com/images/case-study-designs/2.png" alt="header" width="350" height="350">


- O case original pode ser encontrado [aqui](https://8weeksqlchallenge.com/case-study-2/).

## 📚 Sumário
- [Introdução](#introdução)
- [O problema](#o-problema)
- [Dados](#dados)
- [Soluções](#case-study-questions)

## Introdução
Com o objetivo de expandir sua pizzaria, Danny adotou uma abordagem inovadora ao lançar o Pizza Runner. Nesse empreendimento, ele recrutou uma equipe de entregadores para levar pizzas frescas diretamente aos clientes e também contratou desenvolvedores para criar um aplicativo móvel, permitindo aos clientes fazerem seus pedidos de forma conveniente e eficiente.

## O problema

Devido à experiência de Danny como cientista de dados, ele estava bem ciente de que a coleta de dados seria fundamental para o crescimento de seu negócio.

Ele preparou para nós um diagrama de relacionamento de entidades do seu design de banco de dados, mas necessita de assistência adicional para limpar seus dados e aplicar alguns cálculos básicos, a fim de orientar melhor seus entregadores e otimizar as operações do Pizza Runner.

## Dados

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