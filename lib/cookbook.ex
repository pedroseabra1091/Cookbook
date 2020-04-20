defmodule Cookbook do
  import Cookbook.{Recipe}

  require IEx

  alias Cookbook.{Ingredient, Recipe, Repo}

  def random_recipe(), do: random() |>  Repo.one() |> to_recipe

  def all_recipes(), do: Repo.all(Recipe)

  def get_recipe_by_name(recipe_name), do: Recipe |> by_name(recipe_name) |> Repo.all |> to_recipe

  def get_recipes_from_chef(chef_name), do: Recipe |> by_chef(chef_name) |> Repo.all |> to_recipe

  def get_recipes_from_category(category), do: Recipe |> by_category(category) |> Repo.all |> to_recipe

  def get_recipes_by_cooking_time(cooking_time), do: Recipe |> max_cooking_time(cooking_time) |> Repo.all |> to_recipe

  def add_recipe(recipe_params), do: Recipe.insert(recipe_params)

  def update_recipe(name, recipe_params) do
    recipe = Repo.get_by!(Recipe, name: name)

    recipe |> Recipe.update(recipe_params)
  end

  def delete_recipe(name) do
    recipe = Repo.get_by!(Recipe, name: name)

    recipe |> Recipe.delete()
  end

  def add_recipe_ingredients_to_recipe(recipe, recipe_ingredients_params) do
    recipe = recipe |> Repo.preload([recipes_ingredients: [:ingredient]])

    recipe_ingredients = recipe.recipes_ingredients ++ recipe_ingredients_params

    recipe
    |> update(%{recipe_ingredients: recipe_ingredients})
  end

  def update_ingredient(ingredient, ingredient_params) do
    ingredient
    |> Ingredient.update_ingredient(ingredient_params)
  end
end
