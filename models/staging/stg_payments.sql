select
    payment_id,
    customer_id,
    rental_id,
    staff_id,
    amount,
    payment_date::timestamp as paid_at
from {{ source('pagila', 'payment') }}