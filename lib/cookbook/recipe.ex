defmodule Cookbook.Recipe do
  use Ecto.Schema
  use EctoEnum, type: :category, enums: [:meat, :fish, :vegetarian, :vegan]

  alias Cookbook.{Chef, Ingredient, Repo, Recipe}

  import Ecto.{Changeset, Query, Multi}

  schema "recipes" do
    field :name, :string, null: false
    field :steps, {:array, :string}, null: false
    field :cooking_time, :integer, null: false
    field :category, :string, null: false
    field :portions, :integer, nulL: false

    belongs_to :chef, Chef, on_replace: :delete
    many_to_many :ingredients, Ingredient, join_through: "recipes_ingredients", on_delete: :delete_all

    timestamps()
  end

  def insert(params) do
    %Recipe{}
    |> cast_and_validate(params)
    |> Repo.insert()
  end

  def update(recipe, params) do
    recipe
    |> cast_and_validate(params)
    |> Repo.update()
  end

  def delete(recipe), do: recipe |> Repo.delete

  def by_chef(query, chef_name) do
    from r in query,
      join: c in assoc(r, :chef),
      where: ilike(c.name, ^chef_name)
  end

  def with_cooking_time_less_than(query, cooking_time) do
    from r in query,
      where: r.cooking_time <= ^cooking_time
  end

  def name_and_steps(query), do: from r in query, select: map(r, [:name, :steps])

  def bulk_changeset(recipe, params) do
    recipe
    |> cast_and_validate(params)
    |> cast_assoc(:ingredients, with: &Ingredient.changeset/2)
  end

  def changeset(recipe, %{ingredients: ingredients, chef: chef} = params) do
    recipe
    |> cast_and_validate(params)
    |> put_recipe_assoc(:ingredients, ingredients)
    |> put_recipe_assoc(:chef, chef)
  end

  def put_recipe_assoc(recipe, nil), do: recipe
  def put_recipe_assoc(recipe, assoc_schema, assoc_params), do: recipe |> put_assoc(assoc_schema, assoc_params)

  def cast_and_validate(recipe, params) do
    recipe
    |> cast(params, ~w(name steps cooking_time category portions)a)
    |> validate_required(~w(name steps cooking_time category portions)a)
    |> validate_inclusion(:category, ~w(meat fish vegetarian vegan))
    |> validate_number(:cooking_time, greater_than: 0)
    |> validate_number(:portions, greater_than: 0)
  end
end