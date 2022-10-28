{{
  config(
    materialized='table'
  )
}}

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

  ,joins as(

    SELECT DISTINCT 
    
    CAST(DATE_PART('YEAR',events.created_at)||'-'||DATE_PART('MONTH',events.created_at)||'-'||DATE_PART('DAYOFMONTH',events.created_at) as date) as event_date,
    events.session_id,
    events.product_id,
    products.name,
    events.order_id,
    case when events.order_id is not null then 1 else 0 end as purchase_flag
    
    FROM events

    LEFT JOIN products
    on events.product_id = products.product_id

    LEFT JOIN order_items
    ON events.order_id = order_items.order_id

     )

select distinct 
    event_date,
    count(distinct session_id) as all_sessions,
    count(distinct case when purchase_flag = 1 then session_id else null end) as purchase_sessions
  from joins
  group by 1