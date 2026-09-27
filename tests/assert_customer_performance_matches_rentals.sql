with mart_totals as (
    select
        coalesce(sum(total_rentals), 0) as total_rentals,
        coalesce(sum(lifetime_payment_total), 0) as lifetime_payment_total
    from {{ ref('mart_customer_performance') }}
),

source_totals as (
    select
        (select count(*) from {{ ref('stg_rentals') }}) as total_rentals,
        (select coalesce(sum(amount), 0) from {{ ref('stg_payments') }}) as lifetime_payment_total
)

select
    'total_rentals' as check_name,
    m.total_rentals as mart_value,
    s.total_rentals as source_value
from mart_totals m
cross join source_totals s
where m.total_rentals <> s.total_rentals

union all

select
    'lifetime_payment_total' as check_name,
    m.lifetime_payment_total as mart_value,
    s.lifetime_payment_total as source_value
from mart_totals m
cross join source_totals s
where m.lifetime_payment_total <> s.lifetime_payment_total