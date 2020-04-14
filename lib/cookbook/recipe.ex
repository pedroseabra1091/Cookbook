defmodule Cookbook.Recipe do
  use Ecto.Schema
  use EctoEnum, type: :category, enums: [:meat, :fish, :vegetarian, :vegan]

  alias Cookbook.{Chef, Ingredient}

  import Ecto.Query

  schema "recipes" do
    field :name, :string, null: false
    field :steps, {:array, :string}
    field :cooking_time, :integer, default: 0
    field :category, :string
    field :portions, :integer, default: 0

    belongs_to :chef, Chef
    many_to_many :ingredients, Ingredient, join_through: "recipes_ingredients"

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
end