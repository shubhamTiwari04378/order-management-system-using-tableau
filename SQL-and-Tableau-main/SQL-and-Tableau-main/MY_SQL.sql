-- Question 7

-- Write a query to display carton id, (len*width*height) as carton_vol and identify the 
-- optimum carton (carton with the least volume whose volume is greater than the total 
-- volume of all items (len * width * height * product_quantity)) for a given order whose order 
-- id is 10006, Assume all items of an order are packed into one single carton (box).

-- Solution

select carton_ID, min(c.len*c.width*c.height) as carton_vol from carton c
where c.len*c.width*c.height >(select sum(o.product_quantity*p.len*p.width*p.height) as volume from order_items o
inner join product p on o.product_ID=p.product_ID where order_ID=10006);

-- Question 8

-- Write a query to display details (customer id,customer fullname,order id,product quantity) 
-- of customers who bought more than ten (i.e. total order qty) products with credit card or 
-- Net banking as the mode of payment per shipped order. 

-- Solution

SELECT oc.customer_id, concat(oc.customer_fname,' ' ,oc.customer_lname) Name,
oh.order_id, sum(oi.product_quantity) total_quantity from online_customer oc
inner join order_header oh on oc.customer_id=oh.customer_id
inner join order_items oi on oh.order_id=oi.order_id
where oh.order_status='Shipped' and oh.payment_mode IN ('Net Banking', 'Credit Card')
group by oh.order_id
having (total_quantity > 10);


-- Question 9

--  Write a query to display the order_id, customer id and cutomer full name of customers
--  starting with the alphabet "A" along with (product_quantity) as total quantity of products
--  shipped for order ids > 10030. 

-- Solution

SELECT oc.customer_id, oc.customer_fname, oc.customer_lname, oh.order_id, sum(oi.product_quantity) total_quantity from online_customer oc
inner join order_header oh on oc.customer_id=oh.customer_id
inner join order_items oi on oh.order_id=oi.order_id
Where oh.order_status='Shipped'
group by oh.order_id
having (oc.customer_fname like 'A%') and (oh.order_id > 10030);

-- Question 10

-- Write a query to display product class description ,total quantity
-- (sum(product_quantity),Total value (product_quantity * product price) and show which class 
-- of products have been shipped highest(Quantity) to countries outside India other than USA? 
-- Also show the total value of those items.

-- Solution

SELECT product_class_desc, SUM(oi.product_quantity) AS total_qty,  SUM(oi.product_quantity * p.product_price) AS total_value 
FROM Address a 
inner join Online_Customer oc on oc.address_id=a.address_id 
inner join Order_Header oh on oc.customer_id = oh.customer_id  
inner join Order_Items oi on oh.order_id = oi.order_id 
inner join Product p on oi.product_id = p.product_id 
inner join Product_class pc  on p.product_class_code = pc.product_class_code 
WHERE a.country != 'India' AND a.country != 'USA' AND order_status = "shipped" 
GROUP BY product_class_desc ORDER BY total_qty DESC limit 1