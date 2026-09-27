with customers as (
    select *
    from {{ ref('stg_customers') }}
),

rental_metrics as (
    select
        customer_id,
        count(*) as total_rentals,
        min(rented_at) as first_rented_at,
        max(rented_at) as last_rented_at
    from {{ ref('stg_rentals') }}
    group by customer_id
),

payment_metrics as (
    select
        customer_id,
        sum(amount) as lifetime_payment_total
    from {{ ref('stg_payments') }}
    group by customer_id
)

select
    c.customer_id,
    {{ full_name('c.first_name', 'c.last_name') }} as customer_name,
    coalesce(r.total_rentals, 0) as total_rentals,
    r.first_rented_at,
    r.last_rented_at,
    coalesce(p.lifetime_payment_total, 0)::numeric(12, 2) as lifetime_payment_total
from customers c
left join rental_metrics r
    on c.customer_id = r.customer_id
left join payment_metrics p
    on c.customer_id = p.customer_id