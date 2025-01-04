/* First Mission
-- customers tablosu
CREATE TABLE customers(
	customer_id INT PRIMARY KEY,
	name VARCHAR(255),
	email VARCHAR(255),
	city VARCHAR(255),
	address VARCHAR(255)
);


-- products tablosu
CREATE TABLE products (
	product_id INT PRIMARY KEY,
	name VARCHAR(255),
	category VARCHAR(255),
	price NUMERIC,
	stock INT
);

-- orders tablosu
CREATE TABLE orders (
	order_id INT PRIMARY KEY,
	customer_id INT,
	order_date DATE,
	FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- order_items tablosu
CREATE TABLE order_items (
	order_item_id INT PRIMARY KEY,
	order_id INT,
	product_id INT,
	quantity INT,
	unit_price NUMERIC,
	FOREIGN KEY (order_id) REFERENCES orders(order_id),
	FOREIGN KEY(product_id) REFERENCES products(product_id)
);

-- page_visits tablosu
CREATE TABLE page_visits (
	visit_id INT PRIMARY KEY,
	customer_id INT,
	page_url VARCHAR(255),
	visit_timestamp TIMESTAMP,
	time_spent_seconds INT,
	FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- marketing_campaigns tablosu
CREATE TABLE marketing_campaigns (
	campaign_id INT PRIMARY KEY,
	campaign_name VARCHAR(255),
	start_date DATE,
	end_date DATE,
	cost NUMERIC
);

-- campaign_results tablosu
CREATE TABLE campaign_results (
	campaign_id INT,
	customer_id INT,
	conversion BOOLEAN,
	FOREIGN KEY (campaign_id) REFERENCES marketing_campaigns(campaign_id),
	FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

*/

---

/* Second Mission
-- customers tablosuna veri ekle
INSERT INTO customers (customer_id, name, email, city, address) VALUES
(1, 'Ali Yılmaz', 'ali.yilmaz@example.com', 'İstanbul', 'Beşiktaş'),
(2, 'Ayşe Demir', 'ayse.demir@example.com', 'Ankara', 'Çankaya'),
(3, 'Mehmet Kaya', 'mehmet.kaya@example.com', 'İzmir', 'Karşıyaka');

-- products tablosuna veri ekle
INSERT INTO products (product_id, name, category, price, stock) VALUES
(1, 'Akıllı Telefon X', 'Elektronik', 1500.00, 100),
(2, 'Laptop Y', 'Elektronik', 2500.00, 50),
(3, 'T-Shirt Z', 'Giyim', 50.00, 200),
(4, 'Kot Pantolon K', 'Giyim', 100.00, 150),
(5, 'Spor Ayakkabı L', 'Ayakkabı', 200.00, 100);

-- orders tablosuna veri ekle
INSERT INTO orders (order_id, customer_id, order_date) VALUES
(1, 1, '2023-10-26'),
(2, 2, '2023-10-26'),
(3, 1, '2023-10-27');

-- order_items tablosuna veri ekle
INSERT INTO order_items (order_item_id, order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 2, 1500.00),
(2, 1, 3, 1, 50.00),
(3, 2, 2, 1, 2500.00),
(4, 3, 4, 2, 100.00),
(5, 3, 5, 1, 200.00);

*/

---

/* Third Mission
SELECT *
FROM customers;

SELECT *
FROM customers
WHERE city = 'İstanbul';

SELECT name, price
FROM products
WHERE category = 'Elektronik';

SELECT *
FROM products
ORDER BY price DESC;

SELECT category, COUNT(*)
FROM products
GROUP BY category;

SELECT city, COUNT(*) AS customer_count
FROM customers
GROUP BY city;

SELECT category, COUNT(*)
FROM products
GROUP BY category
HAVING COUNT(*) > 1;

-- Hangi sayfalar en çok ziyaret ediliyor
-- Bu sayfalarda ortalama ne kadar zaman geçiriliyor?
SELECT page_url, COUNT(*) AS visit_count, AVG(time_spent_seconds) AS
avg_time_spent
FROM page_visits
GROUP BY page_url
ORDER BY visit_count DESC;

*/

-- SELECT * FROM page_visits;
/*
ALTER TABLE page_visits
ADD COLUMN page_type VARCHAR(255);


UPDATE page_visits SET page_type = 'Anasayfa' WHERE page_url LIKE '/';
UPDATE page_visits SET page_type = 'Urun' WHERE page_url LIKE '/urun%';
UPDATE page_visits SET page_type = 'Kategori' WHERE page_url LIKE '/kategori%';
UPDATE page_visits SET page_type = 'Sepet' WHERE page_url LIKE '/sepet%';
UPDATE page_visits SET page_type = 'Odeme' WHERE page_url LIKE '/odeme%';

SELECT * FROM page_visits;

*/
/*
SELECT page_url, COUNT(*) AS frequency
FROM page_visits
GROUP BY page_url
ORDER BY frequency DESC;


-- page_visits tablosunun yedeğini al
-- CREATE TABLE page_visits_backup AS SELECT * FROM page_visits;

-- page_type sütununu resetle
-- UPDATE page_visits SET page_type = NULL;
*/
/*

-- Ana Sayfa
UPDATE page_visits
SET page_type = 'Ana Sayfa'
WHERE page_url IN ('/', 'main', 'app', 'tag', 'posts');

-- Uygulama
UPDATE page_visits
SET page_type = 'Uygulama'
WHERE page_url LIKE '%/%app/%' OR page_url LIKE '%app/%' OR page_url LIKE '%/app' OR page_url LIKE '%/app/%';

-- Blog
UPDATE page_visits
SET page_type = 'Blog'
WHERE page_url LIKE '%blog%';

-- İçerik
UPDATE page_visits
SET page_type = 'Icerik'
WHERE page_url LIKE '%wp-content%';

-- Arama
UPDATE page_visits
SET page_type = 'Arama'
WHERE page_url LIKE '%search%';

-- Kategori
UPDATE page_visits
SET page_type = 'Kategori'
WHERE page_url ~* '(.*)/categor(y|ies)(/.*)';

-- Etiket
UPDATE page_visits
SET page_type = 'Etiket'
WHERE page_url ~* '(.*)/tag(s)?(/.*)';

-- Kesfet
UPDATE page_visits
SET page_type = 'Kesfet'
WHERE page_url LIKE '%explore%';

-- Liste
UPDATE page_visits
SET page_type = 'Liste'
WHERE page_url LIKE '%list%';

-- Belirsiz
UPDATE page_visits
SET page_type = 'Belirsiz'
WHERE page_type IS NULL;

SELECT * FROM page_visits;


*/

/*
-- Tek sayfalık ziyaretleri tespit et
WITH single_page_visits AS (
    SELECT customer_id
    FROM page_visits
    GROUP BY customer_id
    HAVING COUNT(DISTINCT visit_id) = 1
)
-- Sayfa türlerine göre hemen çıkma oranını hesapla
SELECT
    pv.page_type,
    COUNT(DISTINCT pv.visit_id) AS total_visits,
    COUNT(DISTINCT CASE WHEN spv.customer_id IS NOT NULL THEN pv.visit_id END) AS bounced_visits,
    (COUNT(DISTINCT CASE WHEN spv.customer_id IS NOT NULL THEN pv.visit_id END)::float / COUNT(DISTINCT pv.visit_id)) * 100 AS bounce_rate
FROM
    page_visits pv
LEFT JOIN
    single_page_visits spv ON pv.customer_id = spv.customer_id
GROUP BY
    pv.page_type
ORDER BY
    bounce_rate DESC;
*/

---
/*
WITH funnel AS (
    SELECT
        pv.customer_id,
        MAX(CASE WHEN pv.page_type = 'Anasayfa' THEN 1 ELSE 0 END) AS visited_homepage,
        MAX(CASE WHEN pv.page_type = 'Urun' THEN 1 ELSE 0 END) AS visited_productpage,
        MAX(CASE WHEN oi.order_id IS NOT NULL AND oi.quantity > 0 THEN 1 ELSE 0 END) AS added_to_cart,
        MAX(CASE WHEN o.order_id IS NOT NULL THEN 1 ELSE 0 END) AS purchased
    FROM
        page_visits pv
    LEFT JOIN
        orders o ON pv.customer_id = o.customer_id
    LEFT JOIN
        order_items oi ON o.order_id = oi.order_id
    GROUP BY
        pv.customer_id
)
SELECT
    SUM(visited_homepage) AS homepage_visits,
    SUM(visited_productpage) AS productpage_visits,
    SUM(added_to_cart) AS added_to_cart_count,
    SUM(purchased) AS purchase_count,
    (SUM(visited_productpage)::float / NULLIF(SUM(visited_homepage), 0)) * 100 AS homepage_to_productpage_rate,
    (SUM(added_to_cart)::float / NULLIF(SUM(visited_productpage), 0)) * 100 AS productpage_to_cart_rate,
    (SUM(purchased)::float / NULLIF(SUM(added_to_cart), 0)) * 100 AS cart_to_purchase_rate
FROM
    funnel;



SELECT page_url, page_type
FROM page_visits
ORDER BY page_url;





SELECT DISTINCT page_type FROM page_visits;
*/


-- Ana Sayfayı ziyaret edenler
SELECT COUNT(DISTINCT visit_id) AS homepage_visitors
FROM page_visits
WHERE page_url = 'homepage';


































