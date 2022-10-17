
with
  orders as (
    select * from {{ ref('source_postgres_orders') }} 
  )

  , order_items as (
    select * from {{ ref('source_postgres_order_items') }}
  )

  , products as (
    select * from {{ ref('source_postgres_products') }}
  )



SELECT DISTINCT 
    
    order_items.product_id,

    products.name,
    
    products.price,

    SUM(order_items.quantity) as quantity_sold,
    
    SUM(products.inventory) as total_inventory,
    
    COUNT(DISTINCT orders.order_id) as order_count,
    
    COUNT(DISTINCT orders.user_id) as customer_count




FROM orders

LEFT JOIN order_items
ON orders.order_id = order_items.order_id

LEFT JOIN products
ON order_items.product_id = products.product_id

GROUP BY 1,2,3