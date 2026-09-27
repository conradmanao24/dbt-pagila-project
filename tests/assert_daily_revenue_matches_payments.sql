with mart_totals as (
    select
        coalesce(sum(total_revenue), 0) as total_revenue,
        coalesce(sum(total_payments), 0) as total_payments
    from {{ ref('mart_daily_revenue') }}
),

source_totals as (
    select
        coalesce(sum(amount), 0) as total_revenue,
        count(*) as total_payments
    from {{ ref('stg_payments') }}
)

select
    'total_revenue' as check_name,
    m.total_revenue as mart_value,
    s.total_revenue as source_value
from mart_totals m
cross join source_totals s
where m.total_revenue <> s.total_revenue

union all

select
    'total_payments' as check_name,
    m.total_payments as mart_value,
    s.total_payments as source_value
from mart_totals m
cross join source_totals s
where m.total_payments <> s.total_payments