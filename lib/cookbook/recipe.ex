defmodule Cookbook.Recipe do
  use Ecto.Schema
  use EctoEnum, type: :category, enums: [:meat, :fish, :vegetarian, :vegan]

  alias Cookbook.{Chef, Ingredient, Repo, Recipe}

  import Ecto.{Changeset, Query}

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

  def changeset(recipe, params \\ %{}) do
    recipe
    |> Repo.preload(:ingredients)
    |> cast(params, ~w(name steps cooking_time category portions)a)
    |> validate_required(~w(name steps cooking_time category portions)a)
    |> validate_inclusion(:category, ~w(meat fish vegetarian vegan))
    |> validate_number(:cooking_time, greater_than: 0)
    |> validate_number(:portions, greater_than: 0)
  end
end