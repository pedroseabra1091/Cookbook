defmodule Cookbook.Page do
  use Ecto.Schema

  import Ecto.Changeset

  alias Cookbook.{Chef, Ingredient, Recipe, RecipeIngredient, Repo}

  require IEx

  embedded_schema do
    field :chef_name, :string
    field :recipe_name, :string
    field :steps, {:array, :string}
    field :category, :string
    field :cooking_time, :integer
    field :portions, :integer
    field :ingredients, {:array, :map}
    field :quantity, {:array, :integer}
  end

  @required_fields ~w(chef_name recipe_name steps category cooking_time portions ingredients quantity)a

  def changeset(struct, params) do
    struct
    |> cast(params, @required_fields)
    |> validate_required(@required_fields)
    |> validate_length(:steps, greater_than: 0)
    |> validate_length(:ingredients, min: 0)
    |> validate_length(:quantity, is: length(params[:ingredients]))
    |> validate_inclusion(:category, ~w(meat fish vegetarian vegan))
    |> validate_number(:cooking_time, greater_than: 0)
    |> validate_number(:portions, greater_than: 0)
    |> validate_subset(:quantity, 0..3000)
  end

  def to_multi(params) do
    Ecto.Multi.new()
    |> Ecto.Multi.insert_all(:ingredients, Ingredient, params[:ingredients], [on_conflict: :nothing, returning: true])
    |> Ecto.Multi.insert(:chef, chef_changeset(params), [on_conflict: :nothing, returning: true])
    |> Ecto.Multi.run(:recipe, fn _repo, changes ->
       Repo.insert(recipe_changeset(params, changes))
    end)
    |> Ecto.Multi.run(:recipe_ingredients, fn _repo, changes ->
      {:ok, create_recipe_ingredients(params, changes)}
    end)
  end

  defp chef_changeset(%{chef_name: chef_name}), do: Chef.changeset(%Chef{}, %{name: chef_name})

  defp recipe_changeset(recipe_params, %{chef: chef}) do
    %{recipe_name: recipe_name, steps: steps, category: category, portions: portions, cooking_time: cooking_time} = recipe_params

    Recipe.multi_changeset(%Recipe{},
      %{name: recipe_name, steps: steps, category: category, portions: portions, cooking_time: cooking_time, chef: chef})
  end

  # `insert_all()` doesn't support associations, thus the approach
  def create_recipe_ingredients(%{quantity: quantity}, %{ingredients: {_count, ingredients}, recipe: recipe}) do
    multi_insert = &(multi_recipe_ingredient_insert(&1, &2, recipe))

    ingredients
    |> Enum.with_index
    |> Enum.map(fn {ingredient, index} -> multi_insert.(ingredient, Enum.at(quantity, index)) end)
  end

  def multi_recipe_ingredient_insert(ingredient, quantity, recipe) do
    Ecto.Multi.new()
    |> Ecto.Multi.insert(:recipe_ingredient, recipe_ingredient_changeset(%{recipe: recipe, ingredient: ingredient, quantity: quantity}))
  end

  def recipe_ingredient_changeset(recipe_ingredient) do
    RecipeIngredient.multi_changeset(%RecipeIngredient{}, recipe_ingredient)
  end
end