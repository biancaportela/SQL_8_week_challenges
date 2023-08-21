# 🍜  Danny's Diner
<p align="center">
<img src="https://8weeksqlchallenge.com/images/case-study-designs/1.png" alt="header" width="350" height="350">


- O case original pode ser encontrado [aqui](https://8weeksqlchallenge.com/case-study-1/).


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

**2. Quantos dias cada cliente visitou o restaurante?**

**3. Qual foi o primeiro item do menu comprado por cada cliente?**

**4. Qual é o item mais comprado no menu e quantas vezes foi comprado por todos os clientes?**

**5. Qual item foi o mais popular para cada cliente?**

**6. Qual item foi comprado primeiro pelo cliente após ele se tornar membro?**

**7. Qual item foi comprado logo antes de o cliente se tornar membro?**

**8. Qual é o total de itens e valor gasto para cada membro antes de se tornarem membros?**

**9. Se cada $1 gasto equivale a 10 pontos e o sushi tem um multiplicador de pontos de 2x - quantos pontos cada cliente teria?**

**10. Na primeira semana após um cliente aderir ao programa (incluindo a data de adesão), eles ganham 2x pontos em todos os itens, não apenas no sushi - quantos pontos os clientes A e B têm no final de janeiro?**