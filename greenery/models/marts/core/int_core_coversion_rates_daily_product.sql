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

  , joins as(

    SELECT DISTINCT 
    
    CAST(DATE_PART('YEAR',events.created_at)||'-'||DATE_PART('MONTH',events.created_at)||'-'||DATE_PART('DAYOFMONTH',events.created_at) as date) as event_date,
    events.session_id,
    order_items.product_id,
    products.name as product_name,
    events.order_id,
    case when events.order_id is not null then 1 else 0 end as purchase_flag
    
    FROM events

    LEFT JOIN order_items
    ON events.order_id = order_items.order_id

    LEFT JOIN products
    on order_items.product_id = products.product_id

     )


        select distinct 
        a.event_date,
        a.product_id,
        a.product_name,
        b.all_sessions,
        count(distinct case when purchase_flag = 1 then session_id else null end) as purchase_sessions
    
        from joins a

        left join
        (select event_date, count(distinct session_id) as all_sessions 
        from joins
        group by 1) b
        on a.event_date = b.event_date 

        group by 1,2,3,4
