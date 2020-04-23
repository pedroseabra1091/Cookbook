defmodule Cookbook.RecipeIngredient do
  use Ecto.Schema
  import Ecto.Changeset

  alias Cookbook.{Ingredient, Recipe}

  require IEx

  schema "recipes_ingredients" do
    belongs_to :recipe, Recipe
    belongs_to :ingredient, Ingredient
    field :quantity, :integer
  end

  def changeset(recipe_ingredient, params) do
    recipe_ingredient
    |> cast(params, ~w(:ingredient, :quantity])a)
    |> validate_required(~w(quantity)a)
    |> validate_number(:quantity, greater_than: 0)
  end

  def to_recipe_ingredient(recipe_ingredient) do
    "- #{recipe_ingredient.quantity}#{recipe_ingredient.ingredient.measure_unit} #{recipe_ingredient.ingredient.name}\n"
  end
end