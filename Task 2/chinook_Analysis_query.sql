SELECT * FROM invoice_line;
-- 1. Use Sql To Analyze Top 10 selling product
SELECT t.name AS TrackName,
       SUM(il.quantity) AS TotalSold
FROM invoice_line il
         JOIN Track t ON il.track_id = t.track_id
GROUP BY t.Name
ORDER BY TotalSold DESC
LIMIT 10;

-- 2. Revenue Per Region(Country)
SELECT c.country,
       SUM(il.quantity * il.unit_price) AS total_revenue
FROM invoice_line il
         JOIN Invoice i ON il.invoice_id = i.invoice_id
         JOIN customer c ON i.customer_id = c.customer_id
GROUP BY c.country
ORDER BY total_revenue DESC;

-- 3. Monthly Performance (Revenue Per Month)
SELECT TO_CHAR(DATE_TRUNC('month', i.invoice_date), 'YYYY-MM') AS Month,
       SUM(il.quantity * il.unit_price) AS Revenue
FROM invoice_line il
         JOIN Invoice i ON il.invoice_id = i.invoice_id
GROUP BY Month
ORDER BY Month;

-- 4. Top Artist By Sales
SELECT ar.name AS artist,
       SUM(il.quantity * il.unit_price) AS total_revenue
FROM invoice_line il
         JOIN track t ON il.track_id = t.track_id
         JOIN album al ON t.album_id = al.album_id
         JOIN  artist ar ON al.artist_id = ar.artist_id
GROUP BY ar.name
ORDER BY total_revenue DESC
LIMIT 5;

--5. Best Customers (Lifetime Value)
SELECT c.first_name || ' ' || c.last_name AS customer,
       SUM(il.quantity * il.unit_price) AS total_spent
FROM invoice_line il
         JOIN invoice i ON il.invoice_id = i.invoice_id
         JOIN customer c ON i.customer_id = c.customer_id
GROUP BY customer
ORDER BY total_spent DESC
LIMIT 10;

-- 6. Top Customers by Spending in Each Country
SELECT c.country,
       c.first_name || ' ' || c.last_name AS customer,
       SUM(il.quantity * il.unit_price) AS total_spent,
       RANK() OVER (
           PARTITION BY c.country
           ORDER BY SUM(il.quantity * il.unit_price) DESC
           ) AS rank_in_country
FROM invoice_line il
         JOIN invoice i ON il.invoice_id = i.invoice_id
         JOIN customer c ON i.customer_id = c.customer_id
GROUP BY c.country, c.first_name, c.last_name
ORDER BY c.country, rank_in_country;