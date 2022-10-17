
with
  orders as (
    select * from {{ ref('source_postgres_orders') }} 
  )

  , order_items as (
    select * from {{ ref('source_postgres_order_items') }}
  )

  , users as (
    select * from {{ ref('source_postgres_users') }}
  )

  , addresses as (
    select * from {{ ref('source_postgres_addresses') }}
  )

  , order_item_count as (
    
        SELECT DISTINCT
            orders.user_id,
            orders.order_id,
            order_items.product_id
            
        FROM orders 

        LEFT JOIN order_items
        ON orders.order_id = order_items.order_id

)


SELECT DISTINCT

    users.user_id,
    users.first_name,
    users.last_name,
    users.email,
    users.phone_number,
    users.created_at,
    users.updated_at,
    users.address_id,
    addresses.address,
    addresses.zipcode,
    addresses.state,
    addresses.country,
    COUNT(DISTINCT order_item_count.order_id) as order_count,
    CASE WHEN COUNT(DISTINCT order_item_count.order_id) > 1 THEN 'Repeat Customer' ELSE 'One-Time Customer' END AS repeat_flag,
    COUNT (DISTINCT order_item_count.product_id) as products_owned
    
FROM users

LEFT JOIN addresses
ON users.address_id = addresses.address_id

LEFT JOIN order_item_count
ON users.user_id = order_item_count.user_id

GROUP BY 
    users.user_id,
    users.first_name,
    users.last_name,
    users.email,
    users.phone_number,
    users.created_at,
    users.updated_at,
    users.address_id,
    addresses.address,
    addresses.zipcode,
    addresses.state,
    addresses.country

    







