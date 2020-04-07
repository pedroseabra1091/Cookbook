defmodule Cookbook.Recipe do
  use Ecto.Schema
  use EctoEnum, type: :category, enums: [:meat, :fish, :vegetarian, :vegan]

  schema "recipes" do
    field :name, :string
    field :cooking_time, :float
    field :category, :string
    field :portions, :integer
    belongs_to :chef, Cookbook.Chef
    many_to_many :ingredients, Cookbook.Ingredient, join_through: "recipes_ingredients"
  end
end