with films as (
    select *
    from {{ ref('stg_films') }}
),

film_categories as (
    select
        fc.film_id,
        string_agg(distinct c.name, ', ' order by c.name) as category
    from {{ source('pagila', 'film_category') }} fc
    join {{ source('pagila', 'category') }} c
        on fc.category_id = c.category_id
    group by fc.film_id
),

inventory_metrics as (
    select
        film_id,
        count(*) as inventory_count
    from {{ ref('stg_inventory') }}
    group by film_id
),

rental_metrics as (
    select
        i.film_id,
        count(*) as times_rented
    from {{ ref('stg_rentals') }} r
    join {{ ref('stg_inventory') }} i
        on r.inventory_id = i.inventory_id
    group by i.film_id
)

select
    f.film_id,
    f.title,
    fc.category,
    f.rating,
    rd.description as rating_description,
    f.rental_rate,
    coalesce(i.inventory_count, 0) as inventory_count,
    coalesce(r.times_rented, 0) as times_rented,
    coalesce(i.inventory_count, 0) > 0 as is_available
from films f
left join film_categories fc
    on f.film_id = fc.film_id
left join {{ ref('rating_descriptions') }} rd
    on f.rating = rd.rating
left join inventory_metrics i
    on f.film_id = i.film_id
left join rental_metrics r
    on f.film_id = r.film_id