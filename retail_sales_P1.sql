create database Retail_Sales_Analysis_P1;
USE RETAIL_SALES_ANALYSIS_P1;

select * from retail_sales
 ;
 
/*Data cleaning
*/


select * from retail_sales
where 
    transactions_id is null
    or
	sale_date is null
    or
	sale_time is null
    or
	customer_id is null
    or
	gender is null
    or
	age is null
    or
	category is null
    or
	quantiy is null
    or
	price_per_unit is null
    or
	cogs is null
    or
	total_sale is null
;


/*
Data Exploration
*/

/* How many sales,how many unique customers, how many categories? */


select count(*) as total_sales from retail_sales;
select count(distinct customer_id) as total_customers from retail_sales;
select distinct category from retail_sales;



/*Data Analysis*/

/*
My Analysis & Findings
1.Write a SQL query to retrieve all columns for sales made on '2022-11-05
2.Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than or equal to 4 in the month of Nov-2022
3.Write a SQL query to calculate the total sales (total_sale) for each category.
4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
5.Write a SQL query to find all transactions where the total_sale is greater than 1000.
6.Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
7.Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
8.Write a SQL query to find the top 5 customers based on the highest total sales 
9.Write a SQL query to find the number of unique customers who purchased items from each category.
10.Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
*/


/* 1 */
select * 
from retail_sales
where sale_date='2022-11-05';

/* 2 */
select * from retail_sales
where category='clothing' and
quantiy>=4 and 
date_format(sale_date, '%Y-%m') = '2022-11';


/* 3 */
select category,
       count(transactions_id) as total_sales
	from retail_sales
    group by category;
 
 /* 4 */
select category,
       avg(age)  as avg_age
    from  retail_sales
 group by category
having category='beauty';
 
 /* 5 */
 select * from retail_sales
   where total_sale>1000;
 
 /* 6 */
 select   category,
          gender,
	count(transactions_id) as total_transactions
from retail_sales
	group by category,gender
    order by category;
   
   
   
 /* 7 */  
select year,
avg_month_sale
from
(    
select 
     year(sale_date) as year,
     month(sale_date) as month,
     avg(total_sale) as avg_month_sale ,
     dense_rank() over (partition by year(sale_date)  order by avg(total_sale) )  as r
from retail_sales
group by year,month
) as t1
where r=1;


/* 8 */
select customer_id,
       sum(total_sale) as per_customer_sale
	from retail_sales
group by customer_id
order by per_customer_sale desc
limit 5;

/* 9 */
select category,
       count(distinct customer_id) as customers
	from retail_sales
group by category;


/* 10 */
with cte as 
(
select *,
      case
          when hour(sale_time) <12 then 'morning'
          when hour(sale_time) between 12 and 17 then 'afternoon'
          else 'evening'
      end as shift
	from retail_sales
)
select shift,
       count(transactions_id)
from cte
group by shift;    
