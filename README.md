# dbt Pagila Project

A small dbt project built on the Pagila PostgreSQL sample database.

The project starts from raw Pagila tables in the `public` schema, cleans them into staging views, builds reusable dimensional models, and produces a few marts for customer, revenue, and film analysis.

I also added a simple film-similarity mart using the `film_embedding` data from Pagila and pgvector.

## Stack

- PostgreSQL 18
- pgvector
- dbt Core
- Docker Compose
- DbGate

## Data flow

```text
Pagila (public)
      |
      v
   staging
      |
      v
dimensional / fact
      |
      v
     marts
```

The main flow is:

```text
customer / rental / payment / film / inventory / store
                         |
                         v
                     staging
                         |
                         v
        dim_customers / dim_films / fact_payments
                         |
                         v
 customer performance / daily revenue / film performance
```

The vector branch stays separate from the regular film transformation:

```text
film_embedding
      |
      v
stg_film_embeddings
      |
      v
mart_similar_films
```

## Models

### Staging

Staging models are materialized as views and keep the raw data close to its source while standardizing names and timestamps.

- `stg_customers`
- `stg_rentals`
- `stg_payments`
- `stg_films`
- `stg_inventory`
- `stg_stores`
- `stg_film_embeddings`

### Dimensional and fact models

- `dim_customers` - customer rental and payment summary
- `dim_films` - film metadata, category, inventory, and rental activity
- `fact_payments` - payment transactions enriched with customer, store, rental, and film details

### Marts

- `mart_customer_performance` - customer rental and payment metrics
- `mart_daily_revenue` - daily revenue by store
- `mart_film_performance` - rental and revenue metrics by film
- `mart_similar_films` - top 5 similar films for each film using pgvector cosine similarity

## Running the project

Start PostgreSQL and DbGate:

```powershell
docker compose up -d postgres dbgate
```

On a fresh database volume, the Pagila schema and data are loaded automatically from `docker/init`.

The dbt service is run on demand rather than kept running as a long-lived container.

Run the dbt project:

```powershell
docker compose run --rm dbt dbt build
```

The dbt models are created in the `dbt_pagila` schema.

DbGate is available at:

```text
http://localhost:15424
```

## dbt Docs

Generate the catalog:

```powershell
docker compose run --rm dbt dbt docs generate
```

Serve the documentation locally:

```powershell
docker compose run --rm -p 15480:8080 dbt dbt docs serve --host 0.0.0.0 --port 8080
```

Then open:

```text
http://localhost:15480
```

The docs can be used to inspect model descriptions, dependencies, and lineage.

## Project structure

```text
.
|-- docker/
|   |-- dbt/
|   `-- init/
|-- macros/
|-- models/
|   |-- staging/
|   |-- intermediate/
|   `-- marts/
|-- seeds/
|-- tests/
|-- dbt_project.yml
|-- docker-compose.yml
`-- profiles.yml
```

## Data source

This project uses the Pagila sample database:

https://github.com/devrimgunduz/pagila

dbt documentation:

https://docs.getdbt.com/