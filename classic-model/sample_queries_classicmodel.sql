USE classicmodels;

SELECT *
FROM classicmodels.customers;

-- Report the total number of payments received before October 28, 2004
SELECT
	COUNT(*)
FROM payments
WHERE paymentDate = '2004-10-28';

-- Report the number of customers who have made payments before October 28, 2004
SELECT 
	COUNT(DISTINCT customerNumber)
FROM payments
WHERE paymentDate < '2004-10-28';

-- Retrieve the list of customer numbers for customer who have made a payment before October 28, 2004
SELECT
	DISTINCT(customerNumber)
FROM payments
WHERE paymentDate < '2004-10-28';

-- Retrieve the details all customers who have made a payment before October 28, 2004
SELECT *
FROM customers
WHERE customerNumber IN
	(SELECT DISTINCT customerNumber 
    FROM payments
    WHERE paymentDate < '2004-10-28');
    
-- Retrieve details of all the customers in the United States who have made payments between April 1st 2003 and March 31st 2004
SELECT * 
FROM customers 
WHERE customerNumber IN 
	(SELECT DISTINCT customerNumber 
		FROM payments WHERE paymentDate>"2003-04-01" and paymentDate<"2004-03-31" and country='USA');

-- Find the total number of payments made each customer before October 28, 2004
SELECT
	customerNumber,
    COUNT(*) AS totalPayments
FROM payments
WHERE paymentDate < '2004-10-28'
GROUP BY customerNumber;

-- Find the total amount paid by each customer payment before October 28, 2004
SELECT
	customerNumber,
    SUM(amount) AS totalPayment
FROM payments
WHERE paymentDate < '2004-10-28'
GROUP BY customerNumber;

-- Find the total no. of payments and total payment amount for each customer for payments made before October 28, 2004
SELECT
	customerNumber,
    COUNT(*) AS numberofPayments,
    SUM(amount) AS totalPayment
FROM payments
WHERE paymentDate < '2004-10-28'
GROUP BY customerNumber;

-- Modify the above query to also show the minimum, maximum and average payment value for each customer
SELECT
	customerNumber,
    COUNT(*) AS numberofPayments,
    MIN(amount) AS minPayment,
    MAX(amount) AS maxPayment,
    AVG(amount) AS avgPayment
FROM payments
WHERE paymentDate < '2004-10-28'
GROUP BY customerNumber;

-- Retrieve the customer number for 10 customers who made the highest total payment before October 28, 2004
SELECT
	customerNumber,
    SUM(amount) AS totalPayment
FROM payments
WHERE paymentDate < '2004-10-28'
GROUP BY customerNumber
ORDER BY totalPayment DESC
LIMIT 10;

-- To get the next 10 results, add an `OFFSET` with the number of rows to skip
SELECT
	customerNumber,
    SUM(amount) AS totalPayment
FROM payments
WHERE paymentDate < '2004-10-28'
GROUP BY customerNumber
ORDER BY totalPayment DESC
LIMIT 10
OFFSET 10;

-- Display the full name of point of contact each customer in the United States in upper case, along with their phone number, 
-- sorted by alphabetical order of customer name
SELECT
	customerName,
    CONCAT(contactFirstName,
	" ",
    contactLastName) AS contact,
    phone
FROM customers
WHERE country = 'USA'
ORDER BY customerName;

-- Display the list of the 5 most expensive products in the "Motorcycles" product line with their price (MSRP) rounded to dollars
SELECT 
	productName,
    ROUND(MSRP) AS salesPrice
FROM products
WHERE productLine = 'Motorcycles'
ORDER BY salesPrice DESC
LIMIT 5;

-- Display the product code, product name, buy price, sale price and profit margin percentage 
-- (`(MSRP - buyPrice)*100/buyPrice`) for the 10 products with the highest profit margin. 
-- Round the profit margin to 2 decimals
SELECT 
	productCode,
    productName,
    buyPrice,
    MSRP AS salesPrice,
    ROUND(((MSRP - buyPrice) * 100 / buyPrice), 2) AS profitMargin
FROM products
ORDER BY profitMargin DESC
LIMIT 10;

-- List the largest single payment done by every customer in the year 2004, ordered by the transaction value (highest to lowest)
SELECT
	customerNumber,
    MAX(amount) AS largestPayment
FROM payments
WHERE YEAR(paymentDate) = 2004
GROUP BY customerNumber
ORDER BY largestPayment DESC;

-- Show the total payments received month by month for every year
SELECT 
	YEAR(paymentDate) AS year,
    MONTH(paymentDate) AS month,
    SUM(amount) AS totalPayments
FROM payments
GROUP BY year, month
ORDER BY year, month;

-- Show the 10 most recent payments with customer details (name & phone no.)
SELECT
	p.checkNumber,
    p.paymentDate,
    p.amount,
    c.customerNumber,
    c.customerName,
    c.phone
FROM payments AS p
JOIN customers AS c
	ON p.customerNumber = c.customerNumber
ORDER BY p.paymentDate DESC
LIMIT 10;

-- Show the full office address and phone number for each employee
SELECT
	e.firstName,
    e.lastName,
    o.addressLine1,
    o.addressLine2,
    o.city,
    o.state,
    o.country,
    o.postalCode,
    o.phone
FROM offices o
LEFT JOIN employees e
	ON e.officeCode = o.officeCode;
    
-- show the full order information and product details for order no. 10100
SELECT 
	ordernumber, 
    products.productcode, 
    products.productname,
	products.productdescription,
    quantityordered, 
    priceeach, 
	orderlineNumber 
FROM orderdetails 
JOIN products 
	ON orderdetails.productcode= products.productcode 
WHERE ordernumber='10100';

-- show a list of employees with the name & employee number of their manager
SELECT
		CONCAT(
			e.firstName,
            " ",
			e.lastName) AS employeeName,
        m.employeeNumber AS managerEmployeeNumber,
        CONCAT(
			m.firstName,
            " ",
			m.lastName) AS managerName
FROM employees AS e
LEFT JOIN employees m 
	ON e.reportsTo = m.employeeNumber;	
    
-- Determine the total number of units sold for each product
SELECT 
	productcode, 
    SUM(quantityordered) AS sold_units 
FROM orderdetails 
GROUP BY productcode;

-- how many employees are there in the company
SELECT
	COUNT(*)
FROM employees;

-- what is the total of payments received
SELECT 
	SUM(amount) AS TotalPayments
FROM payments;

-- list the product lines that contain cars
SELECT
	productLine
FROM productlines
WHERE productLine LIKE '%Cars%';

-- report those payments greater than $100,000
SELECT *
FROM payments
WHERE amount > 100000;

-- list the products in each product line
SELECT 
	productline, productName
FROM products
ORDER BY productline, productName;

-- how many products in each product line
SELECT
	productLine, 
    COUNT(*) AS count_of_products
FROM products
GROUP BY productLine
ORDER BY COUNT(*) DESC;

-- what is the minimum payment received
SELECT
	MIN(amount) AS minimum_payment
FROM payments;

-- list all the payments greater than twice the average amount
SELECT *
FROM payments
WHERE amount > 2 * 
	(SELECT
		AVG(amount)
	FROM payments);
    
-- what is the average percentage markup of the MSRP on buyPrice
SELECT
	ROUND(AVG((MSRP - buyPrice)/ MSRP) * 100,2) AS AvgPctMarkup
FROM products;

-- how many distinct products does classicmodels sell
SELECT
	COUNT(DISTINCT productName) AS DistinctProduct
FROM products;

-- report the name and city of customers who don't have sales representatives
SELECT
	customerName,
    city
FROM customers
WHERE salesRepEmployeeNumber IS NULL;

-- what are the names of executives with VP or Manager in their title ? Use the CONCAT function 
SELECT
	CONCAT(firstName, " ", lastName) AS fullName
FROM employees
WHERE jobTitle LIKE '%VP%' OR jobTitle LIKE '%Manager%';

-- which orders have a value greater than $5,000
SELECT 
	orderNumber,
    SUM(priceEach * quantityOrdered)
FROM orderdetails
GROUP BY orderNumber
HAVING SUM(priceEach * quantityOrdered) > 5000
ORDER BY SUM(priceEach * quantityOrdered);

-- 4. For orders containing more than two products, report
-- those products that constitute more than 50% of the value of the order
SELECT orderNumber, 
		productName,  
        ProductsCount,
        contribution
FROM
     (
      SELECT  orderNumber,
              productCode,
              (SELECT Count(*) 
              FROM orderdetails 
				WHERE OrderNumber = Main.orderNumber) As 'ProductsCount',
              quantityOrdered*priceEach As 'Product Value',
              (quantityOrdered*priceEach / (
                                           SELECT SUM(quantityOrdered*priceEach)
                                           FROM orderdetails
                                           WHERE orderNumber = Main.orderNumber ))*100 AS 'Contribution'
      FROM orderdetails Main
      ORDER BY  orderNumber
      )  DataTable
INNER JOIN
Products
ON Products.productCode = DataTable.productCode
WHERE ProductsCount > 2 AND Contribution > 50;

-- list all the products purchased by Herkku Gifts
SELECT 
	productName
FROM products
INNER JOIN orderdetails od ON products.productCode = od.productCode
INNER JOIN orders o ON od.orderNumber = o.orderNumber
INNER JOIN customers c ON o.customerNumber = c.customerNumber
WHERE c.customerName = 'Herkku Gifts';

-- list the products ordered on a Monday
SELECT 
	productName, 
    orderDate, 
    DAYNAME(orderDate) As 'DayName'
FROM products
INNER JOIN orderdetails
	ON products.productCode = orderdetails.productCode
INNER JOIN Orders
	ON orderdetails.orderNumber = orders.orderNumber
WHERE DAYNAME(Orders.orderDate) = 'MONDAY';

-- report the account representative for each customer
SELECT 
	customerName,
    CONCAT(e.firstName," ",e.lastName) AS 'Account Repersentative'
FROM customers
INNER JOIN employees e 
	ON customers.salesRepEmployeeNumber = e.employeeNumber;
    
-- report total payments for Atelier graphique
SELECT 
	c.customerName,
    SUM(payments.amount)
FROM payments
INNER JOIN customers c 
	ON payments.customerNumber = c.customerNumber
WHERE c.customerName = 'Atelier graphique'
GROUP BY c.customerName;

-- report the total payments by Date
SELECT 
	paymentDate,
    SUM(amount) AS 'Amount'
FROM payments
GROUP BY paymentDate;

-- report the products that have not been sold
SELECT * 
FROM products
WHERE NOT EXISTS 
		(SELECT * FROM orderdetails
			WHERE products.productCode = orderdetails.productCode);
            
-- list the amount paid by each customer
SELECT 
	o.customerNumber,
	c.customerName, 
    ROUND(SUM(od.quantityOrdered * od.priceEach),2) AS 'Amount Paid'
FROM customers c
INNER JOIN orders o
	ON c.customerNumber = o.customerNumber
INNER JOIN orderdetails od
	ON o.orderNumber = od.orderNumber
GROUP BY o.customerNumber, c.customerName
ORDER BY SUM(od.quantityOrdered * od.priceEach) DESC;

-- report the number of orders 'On Hold' for each customer
SELECT 
	customerName, 
    COUNT(*) AS 'Orders on Hold'
FROM customers
INNER JOIN orders
	ON customers.customerNumber = orders.customerNumber
WHERE orders.status = 'On Hold'
GROUP BY customerName;

-- report the number of orders 'Disputed' by each customer
SELECT 
	customerName, 
    COUNT(*) AS 'Disputed Orders'
FROM customers
INNER JOIN orders
	ON customers.customerNumber = orders.customerNumber
WHERE orders.status = 'Disputed'
GROUP BY customerName;

-- find products containing the name 'Ford'
SELECT 
	productName As 'Products'
FROM products
WHERE productName LIKE '%Ford%';

-- list products ending in 'ship'
SELECT 
	productName
FROM products
WHERE productName LIKE '%ship';

-- report the number of customers in Denmark, Norway, and Sweden
SELECT 
	customerName
FROM customers
WHERE country IN ('Denmark','Norway','Sweden');

-- what are the products with a product code in the range S700_1000 to S700_1499
SELECT 
	productCode,
    productName
FROM products
WHERE RIGHT(productCode,4) BETWEEN 1000 AND 1499
ORDER BY RIGHT(productCode,4);

-- which customers have a digit in their name
SELECT
	customerName
FROM customers
WHERE customerName RLIKE '[0-9]';

-- list the names of employees called Dianne or Diane
-- watch the spacing in the WHERE clause
SELECT 
	CONCAT(firstName, " ", lastName) AS 'Employee Name'
FROM employees
WHERE lastName RLIKE 'Dianne|Diane'OR
      firstName RLIKE 'Dianne|Diane';
      
-- list the products containing ship or boat in their product name
SELECT 
	productName
FROM products
WHERE productName RLIKE 'ship|boat';

-- list the products with a product code beginning with S700
SELECT
	productCode, productName
FROM products
WHERE productCode LIKE 'S700%';

-- list the names of employees called Larry or Barry
SELECT  *
FROM employees
WHERE ('Larry') IN (lastName, firstName)
      OR ('Barry') IN (lastName, firstName);
      
-- list the names of employees with non-alphabetic characters in their names
SELECT 
	CONCAT(employees.lastName, " ", employees.firstName) AS 'Employee Name'
FROM employees
WHERE CONCAT(employees.lastName, " ", employees.firstName) RLIKE '[0-9%@]';

-- list the vendors whose name ends in Diecast
SELECT 
	productVendor
FROM products
WHERE productVendor LIKE '%Diecast';

-- what is the total number of products per product line
SELECT 
	productline, 
    COUNT(productname) AS numofproducts
FROM Products
GROUP BY productline;

-- what is the number of orders per status
SELECT 
	status, 
    COUNT(ordernumber)
FROM orders
GROUP BY status;

-- list all offices and the number of employees working in each office
SELECT 
	officecode, 
    COUNT(employeenumber)
FROM employees
GROUP BY officecode;

-- list the total number of products per product line where number of products > 3
SELECT 
	productline, 
    COUNT(productcode) AS numofproducts
FROM products
GROUP BY productline
HAVING COUNT(productcode) > 3;

-- list the orderNumber and order total for all orders that totaled more than $60,000.00.
SELECT 
	ordernumber, 
    SUM(quantityordered*priceeach) AS ordertotal
FROM orderdetails
GROUP BY ordernumber
HAVING SUM(quantityordered * priceeach) > 60000;

-- list all customers and their sales rep even if they don't have a sales rep for all customers who do business in California
SELECT 
	customername, 
	firstname, 
    lastname
FROM customers c
LEFT OUTER JOIN employees e
	ON c.salesrepemployeenumber = e.employeenumber
WHERE state = 'CA';

-- for each order, list the order date, the customer name, and the number of products ordered, 
-- descending order and orderded over 16
SELECT 
	orderdate, 
    customername, 
    COUNT(productcode) AS numberofuniqueproducts
FROM customers 
NATURAL JOIN orders 
NATURAL JOIN orderdetails
GROUP BY orderdate, customername
HAVING COUNT(productcode) > 16
ORDER BY numberofuniqueproducts DESC;

-- list the product code, product description and potential profit (quantityinstock*(msrp-buyprice))
-- for all products where we have less than 200 in stock
SELECT 
	productcode, 
	productdescription, 
    SUM(quantityinstock*(msrp-buyprice)) AS totalpotentialprofit
FROM products
WHERE quantityinstock < 200
GROUP BY productcode, productdescription;
