defmodule Cookbook.Ingredient do
  use Ecto.Schema

  alias Cookbook.Ingredient

  import Ecto.Changeset

  schema "ingredients" do
    field :name, :string, null: false

    many_to_many :recipes, Cookbook.Recipe, join_through: "recipe_ingredients"

    timestamps()
  end

  def insert(params) do
    %Ingredient{}
    |> changeset(params)
    |> Repo.insert()
  end

  def update(ingredient, params) do
    ingredient
    |> changeset(params)
    |> Repo.update()
  end

  def delete(ingredient) do
    ingredient
    |> Repo.delete()
  end

  # add a ingredient to a existing recipe changeset
  def changeset(ingredient, %{recipe: recipe} = params) do
    ingredient
    |> cast_and_validate(params)
    |> put_assoc(:recipe, recipe)
  end

  # standard ingredient insertion changeset
  def changeset(ingredient, params) do
    ingredient
    |> cast_and_validate(params)
  end

  def cast_and_validate(ingredient, params) do
    ingredient
    |> cast(params, :name)
    |> validate_required(:name)
  end
end