select
    film_id,
    embedding,
    last_update::timestamp as last_update
from {{ source('pagila', 'film_embedding') }}