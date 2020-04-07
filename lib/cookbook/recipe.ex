defmodule Cookbook.Recipe do
  use Ecto.Schema
  use EctoEnum, type: :category, enums: [:meat, :fish, :vegetarian, :vegan]

  alias Cookbook.{Chef, Ingredient}

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
end