with film_revenue as (
    select
        film_id,
        sum(amount) as total_revenue
    from {{ ref('fact_payments') }}
    group by film_id
)

select
    f.film_id,
    f.title,
    f.category,
    f.rental_rate,
    f.inventory_count,
    coalesce(f.times_rented, 0) as times_rented,
    coalesce(r.total_revenue, 0)::numeric(12, 2) as total_revenue
from {{ ref('dim_films') }} f
left join film_revenue r
    on f.film_id = r.film_id