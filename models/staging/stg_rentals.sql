select
    rental_id,
    customer_id,
    inventory_id,
    staff_id,
    rental_date::timestamp as rented_at,
    return_date::timestamp as returned_at
from {{ source('pagila', 'rental') }}