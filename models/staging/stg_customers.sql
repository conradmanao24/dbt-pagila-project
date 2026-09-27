select
    customer_id,
    first_name,
    last_name,
    email,
    activebool as is_active,
    create_date::timestamp as created_at,
    last_update::timestamp as last_update
from {{ source('pagila', 'customer') }}