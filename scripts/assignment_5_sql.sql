-- Assignment 5: SQL Queries

-- Q6: แสดง product name ทั้งหมด
SELECT product_name FROM Products;

-- Q7: แสดง user ที่ลงทะเบียนปี 2022
SELECT id, name, citizen
FROM Users
WHERE registered_date >= '2022-01-01'
  AND registered_date < '2023-01-01';

-- Q8: แสดงข้อมูล product พร้อม customer (customer_id = '001110001')
SELECT
    p.product_id,
    p.product_name,
    CONCAT(c.first_name, ' ', c.last_name) AS customer_full_name,
    c.citizen AS customer_citizen
FROM Products p
JOIN Customers c ON p.customer_id = c.customer_id
WHERE c.customer_id = '001110001';
