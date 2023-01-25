CREATE VIEW Vendas_a_baixo_preco_tabela AS
    SELECT
        od.order_id as id_pedido,
        p.product_name as Produto,
        od.quantity as Quantidade,
        od.unit_price as Preco_Venda,
        p.unit_price as Preco_Tabela,
        (preco_Tabela - od.unit_price) as Diferenca,
        od.discount as Disconto
    FROM
        order_details as od,products as p
    WHERE
        diferenca > 0
    ORDER BY
        od.unit_price desc;
CREATE VIEW performance_vendedores_2022 AS
    SELECT
        em.first_name + ' ' + em.last_name AS nome,
        SUM(od.unit_price * od.quantity - od.discount) AS total
    FROM
        order_details AS od
    INNER JOIN
        orders AS ord ON (ord.order_id = od.order_id)
    INNER JOIN
        employees AS em ON ( em.employee_id = ord.employee_id)
    WHERE
        DATE_PART(year,ord.order_date) = 2022
    GROUP BY
        Nome
    ORDER BY
        total desc;
CREATE VIEW mais_caros AS
    SELECT
        product_id AS id_produto,
        product_name AS nome,
        unit_price AS preco
    FROM
        products
    GROUP BY
        id_produto,nome,preco
    ORDER BY
        unit_price DESC
    LIMIT 10;
CREATE VIEW crescimento_vendas AS
    WITH for2020  AS (
        SELECT
            sup.supplier_id AS id, sup.company_name AS fornecedor,
            SUM(od.unit_price * od.quantity) AS total_2020
        FROM
            order_details AS od
        INNER JOIN
            products AS p ON (p.product_id = od.product_id)
        INNER JOIN
            suppliers AS sup ON (sup.supplier_id = p.supplier_id)
        INNER JOIN
            orders AS o ON (o.order_id = od.order_id)
        WHERE
            DATE_PART(year, o.order_date) = 2020
        GROUP BY
            id, fornecedor
    ),for2021 AS (
        SELECT
            sup.supplier_id AS id, sup.company_name AS fornecedor,
            SUM(od.unit_price * od.quantity) AS total_2021
        FROM
            order_details od
        INNER JOIN
            products AS p ON (p.product_id = od.product_id)
        INNER JOIN
            suppliers AS sup ON (sup.supplier_id = p.supplier_id)
        INNER JOIN
            orders AS o ON (o.order_id = od.order_id)
        WHERE
            DATE_PART(year, o.order_date) = 2021
        GROUP BY
            id, fornecedor
    ), ambos AS (
        SELECT
            for2021.id,for2020.fornecedor,total_2020,total_2021,total_2021 - total_2020 resultado_dif
        FROM
            for2020
        INNER JOIN
            for2021 ON (for2020.id = for2021.id)
        ORDER BY
            resultado_dif DESC
    )
        SELECT * FROM ambos;
CREATE VIEW mais_vendidos AS
    WITH result AS (
        SELECT
            c.category_name AS categoria, DATE_PART(year, o.order_date) AS ano,
            SUM(od.unit_price * od.quantity - od.discount) AS total,
            row_number() over (partition by ano order by ano,total desc) AS res
        FROM
            categories AS c
        INNER JOIN
            products AS p ON (c.category_id = p.category_id)
        INNER JOIN
            order_details AS od ON (p.product_id = od.product_id)
        INNER JOIN
            orders AS o ON (o.order_id = od.order_id)
        GROUP BY categoria, ano
    ),
    filtro AS (
    SELECT * FROM result WHERE res <=5
    )
    SELECT categoria, ano, total FROM filtro;