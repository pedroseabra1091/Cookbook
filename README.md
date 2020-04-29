# Cookbook ![crappy wooden spoon](crappy-wooden-spoon.png)

Playground created to explore Ecto's capabilities during Elixir session # 5. 

Cookbook's menu includes :man_cook::
- Migrations
- Schemas
- Repo
- Changesets
- Associations
  - `has_many`
  - `many_to_many` 
  - `many_to_many` with fields in the join table
- `cast_assoc` and `put_assoc`
- Bulk operations, Upserts
- Streams, Repo.stream
- Transaction
- Multi with schema changeset validation
- Multi with embedded changeset validation

## Before planning your recipes
- execute `bin/setup` from the root of the project

- execute `mix seeds` from the root of the project.

- `iex -S mix` to access iex shell with the Ecto dependencies
