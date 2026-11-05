-- C7 Convenience Store Database
-- Compatible with MySQL / phpMyAdmin
-- 15 tables, with 5 sample records per table

CREATE DATABASE IF NOT EXISTS c7_convenience_store;
USE c7_convenience_store;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS return_details;
DROP TABLE IF EXISTS returns;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS sale_details;
DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS purchase_details;
DROP TABLE IF EXISTS purchases;
DROP TABLE IF EXISTS inventory;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS suppliers;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS expenses;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS users;

SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role VARCHAR(30) NOT NULL
);

CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_name VARCHAR(100) NOT NULL,
    position VARCHAR(50),
    contact_number VARCHAR(20),
    address VARCHAR(150)
);

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    contact_number VARCHAR(20),
    address VARCHAR(150)
);

CREATE TABLE suppliers (
    supplier_id INT PRIMARY KEY AUTO_INCREMENT,
    supplier_name VARCHAR(100) NOT NULL,
    contact_number VARCHAR(20),
    address VARCHAR(150)
);

CREATE TABLE categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(50) NOT NULL,
    description VARCHAR(150)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100) NOT NULL,
    category_id INT,
    supplier_id INT,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (category_id) REFERENCES categories(category_id),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);

CREATE TABLE inventory (
    inventory_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    stock_quantity INT NOT NULL,
    reorder_level INT NOT NULL,
    last_updated DATE,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE purchases (
    purchase_id INT PRIMARY KEY AUTO_INCREMENT,
    supplier_id INT NOT NULL,
    employee_id INT,
    purchase_date DATE NOT NULL,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

CREATE TABLE purchase_details (
    purchase_detail_id INT PRIMARY KEY AUTO_INCREMENT,
    purchase_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_cost DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (purchase_id) REFERENCES purchases(purchase_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE sales (
    sale_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    employee_id INT,
    sale_date DATE NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

CREATE TABLE sale_details (
    sale_detail_id INT PRIMARY KEY AUTO_INCREMENT,
    sale_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (sale_id) REFERENCES sales(sale_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    sale_id INT NOT NULL,
    payment_method VARCHAR(30) NOT NULL,
    amount_paid DECIMAL(10,2) NOT NULL,
    payment_date DATE NOT NULL,
    FOREIGN KEY (sale_id) REFERENCES sales(sale_id)
);

CREATE TABLE returns (
    return_id INT PRIMARY KEY AUTO_INCREMENT,
    sale_id INT NOT NULL,
    customer_id INT,
    return_date DATE NOT NULL,
    reason VARCHAR(150),
    FOREIGN KEY (sale_id) REFERENCES sales(sale_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE return_details (
    return_detail_id INT PRIMARY KEY AUTO_INCREMENT,
    return_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    reason VARCHAR(150),
    FOREIGN KEY (return_id) REFERENCES returns(return_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE expenses (
    expense_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT,
    expense_name VARCHAR(100) NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    expense_date DATE NOT NULL,
    description VARCHAR(150),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
);

-- =========================
-- SAMPLE DATA: 5 EACH
-- =========================

INSERT INTO users (username, password, role) VALUES
('admin', 'admin123', 'Administrator'),
('cashier01', 'cashier123', 'Cashier'),
('cashier02', 'cashier456', 'Cashier'),
('manager01', 'manager123', 'Manager'),
('stock01', 'stock123', 'Inventory Staff');

INSERT INTO employees (employee_name, position, contact_number, address) VALUES
('Juan Dela Cruz', 'Manager', '09171234567', 'Cagayan de Oro'),
('Maria Santos', 'Cashier', '09181234567', 'Carmen'),
('Pedro Garcia', 'Cashier', '09191234567', 'Lapasan'),
('Ana Reyes', 'Inventory Staff', '09201234567', 'Kauswagan'),
('Mark Flores', 'Store Staff', '09211234567', 'Macasandig');

INSERT INTO customers (customer_name, contact_number, address) VALUES
('John Cruz', '09351234567', 'Carmen'),
('Sarah Lim', '09361234567', 'Lapasan'),
('Michael Tan', '09371234567', 'Kauswagan'),
('Angela Reyes', '09381234567', 'Macasandig'),
('Kevin Garcia', '09391234567', 'Cogon');

INSERT INTO suppliers (supplier_name, contact_number, address) VALUES
('ABC Food Distributors', '09170001111', 'Cagayan de Oro'),
('CDO Beverage Supply', '09170002222', 'Lapasan'),
('Fresh Goods Supplier', '09170003333', 'Carmen'),
('Northern Mindanao Trading', '09170004444', 'Kauswagan'),
('Prime Retail Supply', '09170005555', 'Macasandig');

INSERT INTO categories (category_name, description) VALUES
('Beverages', 'Soft drinks, water and juice'),
('Snacks', 'Chips and snack foods'),
('Instant Food', 'Instant noodles and ready-to-eat food'),
('Personal Care', 'Personal hygiene products'),
('Household', 'Household products');

INSERT INTO products (product_name, category_id, supplier_id, price) VALUES
('Coca-Cola 330ml', 1, 2, 25.00),
('Piattos Cheese 85g', 2, 1, 30.00),
('Lucky Me Pancit Canton', 3, 1, 18.00),
('Safeguard Soap', 4, 3, 35.00),
('Wilkins Water 500ml', 1, 2, 20.00);

INSERT INTO inventory (product_id, stock_quantity, reorder_level, last_updated) VALUES
(1, 100, 20, '2026-10-01'),
(2, 80, 15, '2026-10-01'),
(3, 150, 30, '2026-10-02'),
(4, 60, 10, '2026-10-02'),
(5, 120, 25, '2026-10-03');

INSERT INTO purchases (supplier_id, employee_id, purchase_date, total_amount) VALUES
(1, 4, '2026-10-01', 5000.00),
(2, 4, '2026-10-02', 3500.00),
(3, 4, '2026-10-03', 2800.00),
(4, 4, '2026-10-04', 4200.00),
(5, 4, '2026-10-05', 3000.00);

INSERT INTO purchase_details (purchase_id, product_id, quantity, unit_cost, subtotal) VALUES
(1, 3, 100, 15.00, 1500.00),
(1, 2, 50, 25.00, 1250.00),
(2, 1, 100, 20.00, 2000.00),
(3, 4, 50, 28.00, 1400.00),
(4, 5, 100, 15.00, 1500.00);

INSERT INTO sales (customer_id, employee_id, sale_date, total_amount) VALUES
(1, 2, '2026-10-01', 43.00),
(2, 2, '2026-10-01', 60.00),
(3, 3, '2026-10-02', 35.00),
(4, 3, '2026-10-03', 80.00),
(5, 2, '2026-10-04', 50.00);

INSERT INTO sale_details (sale_id, product_id, quantity, unit_price, subtotal) VALUES
(1, 1, 1, 25.00, 25.00),
(1, 3, 1, 18.00, 18.00),
(2, 2, 2, 30.00, 60.00),
(3, 4, 1, 35.00, 35.00),
(4, 5, 4, 20.00, 80.00);

INSERT INTO payments (sale_id, payment_method, amount_paid, payment_date) VALUES
(1, 'Cash', 43.00, '2026-10-01'),
(2, 'GCash', 60.00, '2026-10-01'),
(3, 'Cash', 35.00, '2026-10-02'),
(4, 'Cash', 80.00, '2026-10-03'),
(5, 'GCash', 50.00, '2026-10-04');

INSERT INTO returns (sale_id, customer_id, return_date, reason) VALUES
(1, 1, '2026-10-02', 'Damaged product'),
(2, 2, '2026-10-03', 'Wrong product'),
(3, 3, '2026-10-04', 'Defective item'),
(4, 4, '2026-10-05', 'Damaged packaging'),
(5, 5, '2026-10-05', 'Wrong item');

INSERT INTO return_details (return_id, product_id, quantity, reason) VALUES
(1, 1, 1, 'Damaged bottle'),
(2, 2, 1, 'Wrong snack'),
(3, 4, 1, 'Damaged soap'),
(4, 5, 1, 'Damaged packaging'),
(5, 3, 1, 'Wrong product');

INSERT INTO expenses (employee_id, expense_name, amount, expense_date, description) VALUES
(1, 'Electricity', 3500.00, '2026-10-01', 'Monthly electricity bill'),
(1, 'Water Bill', 800.00, '2026-10-02', 'Monthly water bill'),
(1, 'Store Supplies', 1200.00, '2026-10-03', 'Cleaning supplies'),
(1, 'Transportation', 500.00, '2026-10-04', 'Supplier transportation'),
(1, 'Maintenance', 1500.00, '2026-10-05', 'Store equipment maintenance');

-- Verify the 15 tables
SHOW TABLES;
