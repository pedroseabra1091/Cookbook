defmodule Cookbook.RecipeIngredient do
  use Ecto.Schema

  alias Cookbook.{Ingredient, Recipe, Repo}

  require IEx

  schema "recipes_ingredients" do
    belongs_to :recipe, Recipe
    belongs_to :ingredient, Ingredient
    field :quantity, :integer
  end

  def to_recipe_ingredient(recipe_ingredient) do
    %{
      name: recipe_ingredient.ingredient.name,
      measure_unit: recipe_ingredient.ingredient.measure_unit,
      quantity: recipe_ingredient.quantity
    }
  end
end