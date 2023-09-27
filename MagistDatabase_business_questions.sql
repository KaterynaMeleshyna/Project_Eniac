#How many products of  tech categories have been sold (within the time window of the database snapshot)? 


SELECT 
    Count(product_category_name),product_category_name

FROM (
    SELECT DISTINCT
        product_category_name,
        order_purchase_timestamp,
        order_status
    FROM 
        order_items ot
    INNER JOIN 
        orders o ON o.order_id = ot.order_id
    INNER JOIN 
        products p ON p.product_id = ot.product_id
    WHERE 
        order_status NOT IN ('unavailable', 'canceled')
        AND order_purchase_timestamp > '2017-04-01 11:59:02'
        AND order_purchase_timestamp < '2018-05-01 16:33:31'
) AS subquery
GROUP BY 
    product_category_name
    Having product_category_name in (
      'audio,','automotivo',
'cds_dvds_musicais',
'climatizacao',
'consoles_games',
'dvds_blu_ray',
'eletrodomesticos',
'eletrodomesticos_2',
'eletronicos',
'eletroportateis',
'informatica_acessorios',
'pc_gamer',
'pcs',
'portateis_casa_forno_e_cafe,'
'portateis_cozinha_e_preparadores_de_alimentos',
'sinalizacao_e_seguranca',
'tablets_impressao_imagem',
'telefonia',
'telefonia_fixa');


#Avg price of these tech categories have been sold (within the time window of the database snapshot)? 


SELECT CAST(AVG(ot.price) AS DECIMAL(10, 1)) AS average_price,
    p.product_category_name
FROM order_items ot
INNER JOIN orders o ON o.order_id = ot.order_id
INNER JOIN products p ON p.product_id = ot.product_id
WHERE o.order_status NOT IN ('unavailable', 'canceled')
  AND o.order_purchase_timestamp > '2017-04-01 11:59:02'
  AND o.order_purchase_timestamp < '2018-05-01 16:33:31'
  AND p.product_category_name IN (
    'audio',
    'automotivo',
    'cds_dvds_musicais',
    'climatizacao',
    'consoles_games',
    'dvds_blu_ray',
    'eletrodomesticos',
    'eletrodomesticos_2',
    'eletronicos',
    'eletroportateis',
    'informatica_acessorios',
    'pc_gamer',
    'pcs',
    'portateis_casa_forno_e_cafe',
    'portateis_cozinha_e_preparadores_de_alimentos',
    'sinalizacao_e_seguranca',
    'tablets_impressao_imagem',
    'telefonia',
    'telefonia_fixa'
  )
GROUP BY p.product_category_name;



-- Creating a temporary table tech_products:
CREATE TEMPORARY TABLE Tproducts AS
SELECT 
    *
FROM 
    products
WHERE 
    product_category_name IN (SELECT
            product_category_name 
        FROM 
            product_category_name_translation 
        WHERE 
            product_category_name_english in (
        'audio',
        'auto',
        'cds_dvds_musicals',
        'air_conditioning',
        'consoles_games',
        'dvds_blu_ray',
        'home_appliances',
        'home_appliances_2',
        'electronics',
        'small_appliances',
        'computers_accessories',
        'pc_gamer',
        'watches_gifts',
        'computers',
        'small_appliances_home_oven_and_coffee',
        'portable_kitchen_food_processors',
        'signaling_and_security',
        'tablets_printing_image',
        'telephony',
        'fixed_telephony'));




#3.1 What categories of tech products does Magist have?

SELECT 
    product_category_name_english
FROM
    product_category_name_translation
WHERE
    product_category_name_english IN ('audio' , 'auto','cds_dvds_musicals',
        'air_conditioning','consoles_games','dvds_blu_ray','home_appliances',
        'home_appliances_2','electronics','small_appliances','computers_accessories',
        'pc_gamer','computers', 'small_appliances_home_oven_and_coffee',
        'portable_kitchen_food_processors','signaling_and_security',
        'tablets_printing_image','telephony','fixed_telephony');
        
# How many (in total) products of these tech categories have been sold (within the time window of the database snapshot)? 


SELECT count(pt.product_category_name_english) total_sold
FROM ((products p
INNER JOIN product_category_name_translation pt ON pt.product_category_name =p.product_category_name )
INNER JOIN order_items ot ON p.product_id=ot.product_id )
WHERE
    product_category_name_english IN ('audio' , 'auto','cds_dvds_musicals',
        'air_conditioning','consoles_games','dvds_blu_ray','home_appliances',
        'home_appliances_2','electronics','small_appliances','computers_accessories',
        'pc_gamer','computers', 'small_appliances_home_oven_and_coffee',
        'portable_kitchen_food_processors','signaling_and_security',
        'tablets_printing_image','telephony','fixed_telephony','watches_gifts')
     ;


Select count(oi.order_id)
from order_items oi 
Join Tproducts tp ON tp.product_id=oi.product_id; # Tech_products='29778' (26.4%)

Select count(oi.order_id)
from order_items oi 
Join products tp ON tp.product_id=oi.product_id; # all products ='112650'


##   What’s the average price of the products being sold?


 Select AVG(price)
    from order_items; # all products '120.65'
    
Select AVG(price)
    from order_items oi
    join Tproducts t ON t.product_id=oi.product_id; # Tech products '141.45'
    
    
## Are expensive tech products popular? *
 
 
 Select count(oi.order_id)
    from order_items oi join Tproducts t ON t.product_id=oi.product_id  # '446' (1.5% from total tech products) have been sold  expensive tech products
																		#'112650' all products have been sold
    Where price>1000;
																		#'29778' Tech products have been sold 
                                                                        
#   How many months of data are included in the magist database?

SELECT 
    YEAR(order_purchase_timestamp) as `Year`,
    MONTH(order_purchase_timestamp) as `Month`
FROM 
    orders
GROUP BY 
    `Year`, `Month`
ORDER BY 
    `Year`, `Month`;    #25 month of data
    
    
    
####  How many sellers are there? How many Tech sellers are there? What percentage of overall sellers are Tech sellers?

Select count(seller_id)      ####  '3095' all sellers
from sellers;

Select count(distinct s.seller_id)
from ((order_items oi
INNER JOIN sellers s ON oi.seller_id=s.seller_id )
INNER JOIN  Tproducts tp ON tp.product_id=oi.product_id);    #'3095' all sellers   #'992' (32%)  tech product sellers 




#####    What is the total amount earned by all sellers? What is the total amount earned by all Tech sellers?

Select Round(sum(price))
From sellers s Join order_items oi On s.seller_id=oi.seller_id;   ##  '13 591 644' ---total amount earned by all sellers


Select  Round(sum(price))
from ((order_items oi
INNER JOIN sellers s ON oi.seller_id=s.seller_id )
INNER JOIN  Tproducts tp ON tp.product_id=oi.product_id);   ####  '4 212 184' ---total amount earned by all Tech sellers






 ######  Average number of orders for all clients .  
    
    SELECT 
    AVG(Order_Count) AS Average_Order_Count
FROM (
    SELECT 
        COUNT(order_id) AS Order_Count
    FROM 
        orders
    GROUP BY 
        customer_id
) AS OrderCounts;


#  Estimated delivery time for tech products
Select   AVG(DATEDIFF(order_estimated_delivery_date, order_purchase_timestamp)) AS Deliver_Duration
FROM 
    ((order_items oi
INNER JOIN tech_products tp ON  oi.product_id= tp.product_id)
INNER JOIN orders o ON o.order_id =oi.order_id );

# delivery time 
SELECT *,
    DATEDIFF(order_delivered_customer_date, order_purchase_timestamp)AS Deliver_Duration
FROM 
    orders;




############## order_reviews  ###############

Select count(distinct order_id)
from order_reviews;             ### '98371'


## Customer ratings or all products

Select Count(review_score) as Count_score ,review_score
from order_reviews
Group by review_score
order by Count_score desc;

## Customer ratings for technical products

SELECT   Count(review_score) as Count_score ,review_score
FROM    ((orders o INNER JOIN order_items oi ON o.order_id =oi.order_id )
                INNER JOIN order_reviews oe ON o.order_id =oe.order_id )
                INNER JOIN Tproducts tp ON tp.product_id = oi.product_id    ### 74.4 % Customer ratings is 4 and 5 
																			### 13.3   Customer ratings is 1 
                Group by review_score
order by Count_score desc;



# total   amount of customer ratings for technical products   

SELECT   Count(review_score) as Count_score 
FROM    ((orders o INNER JOIN order_items oi ON o.order_id =oi.order_id )
                INNER JOIN order_reviews oe ON o.order_id =oe.order_id )
                INNER JOIN Tproducts tp ON tp.product_id = oi.product_id       #  '29504' 
                
;





