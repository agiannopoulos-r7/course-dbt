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

    , promos as (
    select * from {{ ref('source_postgres_promos') }}
  )

SELECT


SELECT DISTINCT 

    orders.order_id,
    orders.user_id,

    order_items.product_id,

    products.name,

    order_items.quantity,

    products.price,

    orders.promo_id,

    promos.discount,

    (order_items.quantity*products.price) AS gross_price,

    ((order_items.quantity*products.price)*promos.discount) AS discount_price

FROM orders

LEFT JOIN order_items
ON orders.order_id = order_items.order_id

LEFT JOIN products
ON order_items.product_id = products.product_id

LEFT JOIN promos
ON orders.promo_id = promos.promo_id