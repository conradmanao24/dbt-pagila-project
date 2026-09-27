with payments as (
    select *
    from {{ ref('stg_payments') }}
)

select
    p.payment_id,
    p.paid_at,
    p.paid_at::date as paid_date,
    p.customer_id,
    {{ full_name('c.first_name', 'c.last_name') }} as customer_name,
    p.staff_id,
    i.store_id,
    p.rental_id,
    i.film_id,
    f.title as film_title,
    p.amount
from payments p
left join {{ ref('stg_customers') }} c
    on p.customer_id = c.customer_id
left join {{ ref('stg_rentals') }} r
    on p.rental_id = r.rental_id
left join {{ ref('stg_inventory') }} i
    on r.inventory_id = i.inventory_id
left join {{ ref('stg_films') }} f
    on i.film_id = f.film_id