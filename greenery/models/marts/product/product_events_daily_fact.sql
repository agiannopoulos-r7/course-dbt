with
  events as (
    select * from {{ ref('source_postgres_events') }} 
  )

  , order_items as (
    select * from {{ ref('source_postgres_order_items') }}
  )

  , products as (
    select * from {{ ref('source_postgres_products') }}
  )

SELECT DISTINCT 
    
    CAST(DATE_PART('YEAR',events.created_at)||'-'||DATE_PART('MONTH',events.created_at)||'-'||DATE_PART('DAYOFMONTH',events.created_at) as date) as event_date,
    events.product_id,
    products.name,
    events.event_type,
    SUM(order_items.quantity) as quantity_sold,
    COUNT(DISTINCT events.event_id) as event_count,
    COUNT(DISTINCT events.user_id) as user_count,
    COUNT(DISTINCT events.order_id) as oders_placed
    
FROM events

LEFT JOIN products
on events.product_id = products.product_id

LEFT JOIN order_items
ON events.order_id = order_items.order_id

GROUP BY 1,2,3,4

