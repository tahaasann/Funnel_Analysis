/* -- Tabloları oluşturmak
CREATE TABLE IF NOT EXISTS page_visits2 (
            visitor_id INT,
            page VARCHAR(50),
            visit_timestamp TIMESTAMP
        );

CREATE TABLE IF NOT EXISTS orders2 (
            order_id SERIAL PRIMARY KEY,
            visitor_id INT,
            order_timestamp TIMESTAMP,
            amount INT
        );
*/

-- Anasayfa ziyaretçilerini hesaplama
SELECT COUNT(DISTINCT visitor_id) AS homepage_visitors
FROM page_visits2
WHERE page = 'homepage';


SELECT COUNT(DISTINCT visitor_id) AS product_page_visitors
FROM page_visits2
WHERE page = 'product_page';

SELECT COUNT(DISTINCT visitor_id) AS cart_visitors
FROM page_visits2
WHERE page = 'cart';

SELECT COUNT(DISTINCT visitor_id) AS order_completers
FROM orders2;


SELECT visitor_id, MIN(page) AS first_visited_page
FROM page_visits2
GROUP BY visitor_id;

WITH homepage_users AS (
    SELECT DISTINCT visitor_id
    FROM page_visits2
    WHERE page = 'homepage'
)
SELECT 
    'homepage' AS start_page,
    COUNT(DISTINCT hu.visitor_id) AS homepage_visitors,
    COUNT(DISTINCT CASE WHEN pv.page = 'product_page' THEN pv.visitor_id END) AS product_page_visitors,
    COUNT(DISTINCT CASE WHEN pv.page = 'cart' THEN pv.visitor_id END) AS cart_visitors,
    COUNT(DISTINCT CASE WHEN o.visitor_id IS NOT NULL THEN o.visitor_id END) AS order_completers
FROM homepage_users hu
LEFT JOIN page_visits2 pv ON hu.visitor_id = pv.visitor_id
LEFT JOIN orders2 o ON hu.visitor_id = o.visitor_id;


WITH cart_users AS (
    SELECT DISTINCT visitor_id
    FROM page_visits2
    WHERE page = 'cart'
)
SELECT 
    'cart' AS start_page,
    COUNT(DISTINCT cu.visitor_id) AS cart_page_visitors,
    COUNT(DISTINCT CASE WHEN o.visitor_id IS NOT NULL THEN o.visitor_id END) AS order_completers
FROM cart_users cu
LEFT JOIN orders2 o ON cu.visitor_id = o.visitor_id;

