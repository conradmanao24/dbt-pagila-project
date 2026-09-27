select
    paid_date,
    store_id,
    count(*) as total_payments,
    count(distinct customer_id) as unique_customers,
    sum(amount)::numeric(12, 2) as total_revenue
from {{ ref('fact_payments') }}
group by
    paid_date,
    store_id