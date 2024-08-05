WITH total AS (
    SELECT 
        s.order_date,
        s.productkey,
        s.currency_code,
        SUM(p.profit_per_unit * s.quantity) AS total_usd_profit
    FROM sales s
    JOIN products p ON s.productkey = p.productkey
    GROUP BY s.order_date, s.productkey, s.currency_code
),
converted_profit AS (
    SELECT 
        t.order_date,
        t.productkey,
        t.currency_code,
        ROUND(t.total_usd_profit * e.exchange_rate, 2) AS profit_in_local_currency
    FROM total t
    JOIN exchange e ON t.currency_code = e.currency_code AND t.order_date = e.date
)
SELECT 
    order_date,
    productkey,
    currency_code,
    sum(profit_in_local_currency)
FROM converted_profit
WHERE order_date BETWEEN '2016-01-01' AND '2016-01-31'
order by  order_date, productkey, currency_code
LIMIT 50000;

==========================================================================================================================================
WITH total AS (
    SELECT 
        s.order_date,
        s.productkey,
        s.currency_code,
        SUM(p.profit_per_unit * s.quantity) AS total_usd_profit
    FROM sales s
    JOIN products p ON s.productkey = p.productkey
    GROUP BY s.order_date, s.productkey, s.currency_code
),
converted_profit AS (
    SELECT 
        t.order_date,
        t.productkey,
        t.currency_code,
        ROUND(t.total_usd_profit * e.Exchange, 2) AS profit_in_local_currency
    FROM total t
    JOIN exchange e 
      ON t.currency_code = e.Currency 
      AND t.order_date = e.Date
)
SELECT *
FROM converted_profit
WHERE order_date BETWEEN '2016-01-01' AND '2021-12-31'
ORDER BY profit_in_local_currency desc
limit 5
===========================================================================================================
SELECT c.Country, c.Name, SUM(s.Quantity) as Num_of_products_baught
FROM sales s
JOIN customers c ON c.CustomerKey = s.CustomerKey
GROUP BY c.Country, c.Name
order by Num_of_products_baught desc
limit 10;
============================================================================================================
SELECT 
    r.Country,
    SUM(s.Quantity) AS Total_quantity_of_sold_by_Store
FROM 
    sales s
JOIN 
    stores r ON s.StoreKey = r.StoreKey
GROUP BY 
    r.Country
ORDER BY 
    Total_quantity_of_sold_by_Store DESC
    limit 5;
================================================================================================================
SELECT YEAR(order_date) AS year, SUM(profit_in_local_currency) AS total_profit_by_year
FROM sales_profit
GROUP BY YEAR(order_date)
ORDER BY total_profit_by_year DESC;
================================================================================================================
WITH quantity AS (
    SELECT 
        p.Product_Name,
        s.Quantity,
        p.Subcategory,
        s.order_date,
        s.CustomerKey
    FROM sales s
    JOIN products p ON s.ProductKey = p.ProductKey
),
final AS (
    SELECT 
        q.Quantity,
        q.Product_Name,
        q.order_date,
        c.CustomerKey,
        c.Birthday,
        TIMESTAMPDIFF(YEAR, c.Birthday, q.order_date) AS age
    FROM quantity q
    JOIN customers c ON c.CustomerKey = q.CustomerKey
),
age_ranges AS (
    SELECT 
        f.Product_Name, 
        CASE 
            WHEN f.age BETWEEN 0 AND 10 THEN '0-10'
            WHEN f.age BETWEEN 11 AND 20 THEN '11-20'
            WHEN f.age BETWEEN 21 AND 30 THEN '21-30'
            WHEN f.age BETWEEN 31 AND 40 THEN '31-40'
            WHEN f.age BETWEEN 41 AND 50 THEN '41-50'
            WHEN f.age BETWEEN 51 AND 60 THEN '51-60'
            WHEN f.age BETWEEN 61 AND 70 THEN '61-70'
            WHEN f.age BETWEEN 71 AND 80 THEN '71-80'
            WHEN f.age BETWEEN 81 AND 90 THEN '81-90'
            ELSE '90+' 
        END AS age_range 
    FROM final f
),
ranked_categories AS (
    SELECT 
        ag.Product_Name,
        ag.age_range,
        COUNT(*) AS category_count,
        ROW_NUMBER() OVER (PARTITION BY ag.age_range ORDER BY COUNT(*) DESC) AS rank_num
    FROM 
        age_ranges ag
    GROUP BY 
        ag.Product_Name, ag.age_range
)
SELECT 
    rc.age_range,
    rc.Product_Name,
    rc.category_count
FROM 
    ranked_categories rc
WHERE 
    rc.rank_num = 1
ORDER BY 
    rc.age_range ASC;
=======================================================================================================================
select p.Product_Name,p.ProductKey,s.profit_in_local_currency
from sales_profit s
join products p on p.ProductKey=s.productkey
order by s.profit_in_local_currency desc
limit 5;

=========================================================================================================================
select p.Product_Name,p.ProductKey,sum(s.Quantity) as Total_Quantity_of_sale
from sales s
join products p on p.ProductKey=s.ProductKey
group by p.Product_Name,p.ProductKey
order by sum(s.Quantity) desc
limit 5;
===========================================================================================================================
WITH Total_Sale AS (
    SELECT 
        s.order_date,
        s.productkey,
        s.currency_code,
        SUM(p.Unit_Price_USD * s.quantity) AS total_usd_Sale
    FROM sales s
    JOIN products p ON s.productkey = p.productkey
    GROUP BY s.order_date, s.productkey, s.currency_code
),
converted_profit AS (
    SELECT 
        t.order_date,
        t.productkey,
        t.currency_code,
        ROUND(t.total_usd_Sale * e.Exchange, 2) AS sales_in_local_currency
    FROM Total_Sale t
    JOIN exchange e 
      ON t.currency_code = e.Currency 
      AND t.order_date = e.Date
)
SELECT 
    SUM(sales_in_local_currency) AS total_sales_in_local_currency
FROM 
    converted_profit
WHERE 
    order_date BETWEEN '2016-01-01' AND '2021-12-31';
=================================================================================================================
select currency_code,sum(profit_in_local_currency) as profit_by_currency
from sales_profit
group by currency_code
order by  profit_by_currency desc;
================================================================================================================
