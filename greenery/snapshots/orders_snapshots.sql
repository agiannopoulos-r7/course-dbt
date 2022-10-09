{% snapshot orders_snapshots %}

{{
  config(
    target_database = 'dev_db',
    target_schema = 'dbt_athenagiannopoulos',
    strategy='check',
    unique_key='order_id',
    check_cols=['status'],
   )
}}

  SELECT * FROM {{ source('postgres', 'orders') }}

{% endsnapshot %}