<html>
<head>
<title>chinook_queries.sql</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<style type="text/css">
.s0 { color: #cf8e6d;}
.s1 { color: #bcbec4;}
.s2 { color: #bcbec4;}
.s3 { color: #7a7e85;}
.s4 { color: #2aacb8;}
.s5 { color: #6aab73;}
</style>
</head>
<body bgcolor="#1e1f22">
<table CELLSPACING=0 CELLPADDING=5 COLS=1 WIDTH="100%" BGCOLOR="#606060" >
<tr><td><center>
<font face="Arial, Helvetica" color="#000000">
chinook_queries.sql</font>
</center></td></tr></table>
<pre><span class="s0">SELECT </span><span class="s1">* </span><span class="s0">FROM </span><span class="s1">invoice_line</span><span class="s2">;</span>
<span class="s3">-- 1. Use Sql To Analyze Top 10 selling product</span>
<span class="s0">SELECT </span><span class="s1">t</span><span class="s2">.</span><span class="s1">name </span><span class="s0">AS </span><span class="s1">TrackName</span><span class="s2">,</span>
       <span class="s1">SUM</span><span class="s2">(</span><span class="s1">il</span><span class="s2">.</span><span class="s1">quantity</span><span class="s2">) </span><span class="s0">AS </span><span class="s1">TotalSold</span>
<span class="s0">FROM </span><span class="s1">invoice_line il</span>
         <span class="s0">JOIN </span><span class="s1">Track t </span><span class="s0">ON </span><span class="s1">il</span><span class="s2">.</span><span class="s1">track_id = t</span><span class="s2">.</span><span class="s1">track_id</span>
<span class="s0">GROUP BY </span><span class="s1">t</span><span class="s2">.</span><span class="s1">Name</span>
<span class="s0">ORDER BY </span><span class="s1">TotalSold </span><span class="s0">DESC</span>
<span class="s0">LIMIT </span><span class="s4">10</span><span class="s2">;</span>

<span class="s3">-- 2. Revenue Per Region(Country)</span>
<span class="s0">SELECT c</span><span class="s2">.</span><span class="s1">country</span><span class="s2">,</span>
       <span class="s1">SUM</span><span class="s2">(</span><span class="s1">il</span><span class="s2">.</span><span class="s1">quantity * il</span><span class="s2">.</span><span class="s1">unit_price</span><span class="s2">) </span><span class="s0">AS </span><span class="s1">total_revenue</span>
<span class="s0">FROM </span><span class="s1">invoice_line il</span>
         <span class="s0">JOIN </span><span class="s1">Invoice i </span><span class="s0">ON </span><span class="s1">il</span><span class="s2">.</span><span class="s1">invoice_id = i</span><span class="s2">.</span><span class="s1">invoice_id</span>
         <span class="s0">JOIN </span><span class="s1">customer </span><span class="s0">c ON </span><span class="s1">i</span><span class="s2">.</span><span class="s1">customer_id = </span><span class="s0">c</span><span class="s2">.</span><span class="s1">customer_id</span>
<span class="s0">GROUP BY c</span><span class="s2">.</span><span class="s1">country</span>
<span class="s0">ORDER BY </span><span class="s1">total_revenue </span><span class="s0">DESC</span><span class="s2">;</span>

<span class="s3">-- 3. Monthly Performance (Revenue Per Month)</span>
<span class="s0">SELECT </span><span class="s1">TO_CHAR</span><span class="s2">(</span><span class="s1">DATE_TRUNC</span><span class="s2">(</span><span class="s5">'month'</span><span class="s2">, </span><span class="s1">i</span><span class="s2">.</span><span class="s1">invoice_date</span><span class="s2">), </span><span class="s5">'YYYY-MM'</span><span class="s2">) </span><span class="s0">AS Month</span><span class="s2">,</span>
       <span class="s1">SUM</span><span class="s2">(</span><span class="s1">il</span><span class="s2">.</span><span class="s1">quantity * il</span><span class="s2">.</span><span class="s1">unit_price</span><span class="s2">) </span><span class="s0">AS </span><span class="s1">Revenue</span>
<span class="s0">FROM </span><span class="s1">invoice_line il</span>
         <span class="s0">JOIN </span><span class="s1">Invoice i </span><span class="s0">ON </span><span class="s1">il</span><span class="s2">.</span><span class="s1">invoice_id = i</span><span class="s2">.</span><span class="s1">invoice_id</span>
<span class="s0">GROUP BY Month</span>
<span class="s0">ORDER BY Month</span><span class="s2">;</span>

<span class="s3">-- 4. Top Artist By Sales</span>
<span class="s0">SELECT </span><span class="s1">ar</span><span class="s2">.</span><span class="s1">name </span><span class="s0">AS </span><span class="s1">artist</span><span class="s2">,</span>
       <span class="s1">SUM</span><span class="s2">(</span><span class="s1">il</span><span class="s2">.</span><span class="s1">quantity * il</span><span class="s2">.</span><span class="s1">unit_price</span><span class="s2">) </span><span class="s0">AS </span><span class="s1">total_revenue</span>
<span class="s0">FROM </span><span class="s1">invoice_line il</span>
         <span class="s0">JOIN </span><span class="s1">track t </span><span class="s0">ON </span><span class="s1">il</span><span class="s2">.</span><span class="s1">track_id = t</span><span class="s2">.</span><span class="s1">track_id</span>
         <span class="s0">JOIN </span><span class="s1">album al </span><span class="s0">ON </span><span class="s1">t</span><span class="s2">.</span><span class="s1">album_id = al</span><span class="s2">.</span><span class="s1">album_id</span>
         <span class="s0">JOIN  </span><span class="s1">artist ar </span><span class="s0">ON </span><span class="s1">al</span><span class="s2">.</span><span class="s1">artist_id = ar</span><span class="s2">.</span><span class="s1">artist_id</span>
<span class="s0">GROUP BY </span><span class="s1">ar</span><span class="s2">.</span><span class="s1">name</span>
<span class="s0">ORDER BY </span><span class="s1">total_revenue </span><span class="s0">DESC</span>
<span class="s0">LIMIT </span><span class="s4">5</span><span class="s2">;</span>

<span class="s3">--5. Best Customers (Lifetime Value)</span>
<span class="s0">SELECT c</span><span class="s2">.</span><span class="s1">first_name || </span><span class="s5">' ' </span><span class="s1">|| </span><span class="s0">c</span><span class="s2">.</span><span class="s1">last_name </span><span class="s0">AS </span><span class="s1">customer</span><span class="s2">,</span>
       <span class="s1">SUM</span><span class="s2">(</span><span class="s1">il</span><span class="s2">.</span><span class="s1">quantity * il</span><span class="s2">.</span><span class="s1">unit_price</span><span class="s2">) </span><span class="s0">AS </span><span class="s1">total_spent</span>
<span class="s0">FROM </span><span class="s1">invoice_line il</span>
         <span class="s0">JOIN </span><span class="s1">invoice i </span><span class="s0">ON </span><span class="s1">il</span><span class="s2">.</span><span class="s1">invoice_id = i</span><span class="s2">.</span><span class="s1">invoice_id</span>
         <span class="s0">JOIN </span><span class="s1">customer </span><span class="s0">c ON </span><span class="s1">i</span><span class="s2">.</span><span class="s1">customer_id = </span><span class="s0">c</span><span class="s2">.</span><span class="s1">customer_id</span>
<span class="s0">GROUP BY </span><span class="s1">customer</span>
<span class="s0">ORDER BY </span><span class="s1">total_spent </span><span class="s0">DESC</span>
<span class="s0">LIMIT </span><span class="s4">10</span><span class="s2">;</span>

<span class="s3">-- 6. Top Customers by Spending in Each Country</span>
<span class="s0">SELECT c</span><span class="s2">.</span><span class="s1">country</span><span class="s2">,</span>
       <span class="s0">c</span><span class="s2">.</span><span class="s1">first_name || </span><span class="s5">' ' </span><span class="s1">|| </span><span class="s0">c</span><span class="s2">.</span><span class="s1">last_name </span><span class="s0">AS </span><span class="s1">customer</span><span class="s2">,</span>
       <span class="s1">SUM</span><span class="s2">(</span><span class="s1">il</span><span class="s2">.</span><span class="s1">quantity * il</span><span class="s2">.</span><span class="s1">unit_price</span><span class="s2">) </span><span class="s0">AS </span><span class="s1">total_spent</span><span class="s2">,</span>
       <span class="s1">RANK</span><span class="s2">() </span><span class="s0">OVER </span><span class="s2">(</span>
           <span class="s0">PARTITION BY c</span><span class="s2">.</span><span class="s1">country</span>
           <span class="s0">ORDER BY </span><span class="s1">SUM</span><span class="s2">(</span><span class="s1">il</span><span class="s2">.</span><span class="s1">quantity * il</span><span class="s2">.</span><span class="s1">unit_price</span><span class="s2">) </span><span class="s0">DESC</span>
           <span class="s2">) </span><span class="s0">AS </span><span class="s1">rank_in_country</span>
<span class="s0">FROM </span><span class="s1">invoice_line il</span>
         <span class="s0">JOIN </span><span class="s1">invoice i </span><span class="s0">ON </span><span class="s1">il</span><span class="s2">.</span><span class="s1">invoice_id = i</span><span class="s2">.</span><span class="s1">invoice_id</span>
         <span class="s0">JOIN </span><span class="s1">customer </span><span class="s0">c ON </span><span class="s1">i</span><span class="s2">.</span><span class="s1">customer_id = </span><span class="s0">c</span><span class="s2">.</span><span class="s1">customer_id</span>
<span class="s0">GROUP BY c</span><span class="s2">.</span><span class="s1">country</span><span class="s2">, </span><span class="s0">c</span><span class="s2">.</span><span class="s1">first_name</span><span class="s2">, </span><span class="s0">c</span><span class="s2">.</span><span class="s1">last_name</span>
<span class="s0">ORDER BY c</span><span class="s2">.</span><span class="s1">country</span><span class="s2">, </span><span class="s1">rank_in_country</span><span class="s2">;</span></pre>
</body>
</html>