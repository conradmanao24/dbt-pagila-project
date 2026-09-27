with nearest_films as (
    select
        base.film_id,
        candidate.similar_film_id,
        candidate.similarity_score
    from {{ ref('stg_film_embeddings') }} base
    cross join lateral (
        select
            other.film_id as similar_film_id,
            1 - (base.embedding <=> other.embedding) as similarity_score
        from {{ ref('stg_film_embeddings') }} other
        where other.film_id <> base.film_id
        order by base.embedding <=> other.embedding, other.film_id
        limit 5
    ) candidate
),

ranked as (
    select
        film_id,
        similar_film_id,
        similarity_score,
        row_number() over (
            partition by film_id
            order by similarity_score desc, similar_film_id
        ) as similarity_rank
    from nearest_films
)

select
    r.film_id,
    f.title as film_title,
    r.similar_film_id,
    sf.title as similar_film_title,
    round(r.similarity_score::numeric, 6) as similarity_score,
    r.similarity_rank
from ranked r
join {{ ref('dim_films') }} f
    on r.film_id = f.film_id
join {{ ref('dim_films') }} sf
    on r.similar_film_id = sf.film_id