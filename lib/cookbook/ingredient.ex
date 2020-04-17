defmodule Cookbook.Ingredient do
  use Ecto.Schema
  use EctoEnum, type: :measure_unit, enums: [:kg, :g, :l]

  alias Cookbook.{Repo, Ingredient, RecipeIngredient}

  import Ecto.Changeset

  require IEx

  schema "ingredients" do
    field :name, :string, null: false
    field :measure_unit, :string

    has_many :recipes_ingredients, RecipeIngredient
    has_many :recipes, through: [:recipes_ingredients, :recipe]

    timestamps()
  end

  def insert_ingredient(params) do
    %Ingredient{}
    |> changeset(params)
    |> Repo.insert()
  end

  def update_ingredient(ingredient, params) do
    ingredient
    |> changeset(params)
    |> Repo.update()
  end

  def delete_ingredient(ingredient) do
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
    |> put_assoc(:recipes_ingredients, params[:recipes_ingredients])
  end

  def cast_and_validate(ingredient, params) do
    ingredient
    |> cast(params, ~w(name)a)
    |> validate_required(~w(name)a)
    |> unique_constraint(:name)
  end
end