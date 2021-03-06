defmodule Cookbook.Recipe do
  use Ecto.Schema
  use EctoEnum, type: :category, enums: [:meat, :fish, :vegetarian, :vegan]

  alias Cookbook.{Chef, Ingredient, Repo, Recipe, RecipeIngredient}

  import Ecto.{Changeset, Query}

  require IEx

  schema "recipes" do
    field :name, :string, null: false
    field :steps, {:array, :string}, null: false
    field :cooking_time, :integer, null: false
    field :category, :string, null: false
    field :portions, :integer, nulL: false

    belongs_to :chef, Chef, on_replace: :delete

    has_many :recipes_ingredients, RecipeIngredient
    has_many :ingredients, through: [:recipes_ingredients, :ingredient]

    timestamps()
  end

  def insert(params) do
    %Recipe{}
    |> changeset(params)
    |> Repo.insert()
  end

  def insert!(params) do
    %Recipe{}
    |> changeset(params)
    |> Repo.insert!()
  end

  def update(recipe, params) do
    recipe
    |> changeset(params)
    |> Repo.update()
  end

  def delete(recipe), do: recipe |> Repo.delete

  def by_name(query, nil), do: query
  def by_name(query, name) do
    from r in query,
      where: r.name == ^String.downcase(name)
  end

  def by_chef(query, nil), do: query
  def by_chef(query, chef_name) do
    from r in query,
      join: c in assoc(r, :chef),
      where: ilike(c.name, ^"#{chef_name}%")
  end

  def max_cooking_time(query, nil), do: query
  def max_cooking_time(query, cooking_time) do
    from r in query,
      where: r.cooking_time <= ^cooking_time
  end

  def by_category(query, nil), do: query
  def by_category(query, category) do
    from r in query,
      where: r.category == ^category
  end

  def random(query \\ Recipe) do
    from r in query,
      order_by: fragment("RANDOM()"),
      limit: 1
  end

  def name_and_steps(query), do: from r in query, select: map(r, [:name, :steps])

  def to_recipe(recipes) when is_list(recipes), do: Enum.map(recipes, &to_recipe/1)
  def to_recipe(recipe) do
    recipe_ingredients = recipe
                  |> Repo.preload([recipes_ingredients: [:ingredient]])
                  |> Map.get(:recipes_ingredients)
                  |> Enum.map(&RecipeIngredient.to_recipe_ingredient/1)

    recipe_steps = Enum.join(recipe.steps, "\n\n")

    recipe="\n==== #{String.capitalize(recipe.name)} ====\n\nIngredients:\n#{recipe_ingredients}\nSteps:\n\n#{recipe_steps}\n\nCooking time: #{recipe.cooking_time} min\n\nPortions: #{recipe.portions}"

    IO.puts(recipe)
  end

  def multi_changeset(recipe, params) do
    recipe
    |> cast(params, ~w(name steps cooking_time category portions)a)
    |> put_assoc(:chef, params[:chef])
  end

  def changeset(recipe, params) do
    recipe
    |> cast_and_validate(params)
    |> put_recipe_assoc(:recipes_ingredients, parse_ingredients(params[:recipe_ingredients]))
    |> put_recipe_assoc(:chef, params[:chef])
  end

  def parse_ingredients(nil), do: nil
  def parse_ingredients(recipe_ingredients) do
    recipe_ingredients
    |> Enum.map(&get_or_build_ingredient/1)
  end

  # used to pattern match a ingredient when updating a recipe with new recipe_ingredients
  def get_or_build_ingredient(%{ingredient: %Ingredient{id: _id}} = recipe_ingredient), do: recipe_ingredient

  def get_or_build_ingredient(%{ingredient: ingredient} = recipe_ingredient) do
    ingredient = Repo.get_by(Ingredient, name: ingredient.name) || struct(Ingredient, ingredient)

    %{ingredient: ingredient, quantity: recipe_ingredient.quantity}
  end

  def put_recipe_assoc(recipe, _assoc_schema, nil), do: recipe

  def put_recipe_assoc(recipe, assoc_schema, assoc_params) do
    recipe |> put_assoc(assoc_schema, assoc_params)
  end

  def cast_and_validate(recipe, params) do
    recipe
    |> cast(params, ~w(name steps cooking_time category portions)a)
    |> validate_required(~w(name steps cooking_time category portions)a)
    |> validate_inclusion(:category, ~w(meat fish vegetarian vegan))
    |> validate_number(:cooking_time, greater_than: 0)
    |> validate_number(:portions, greater_than: 0)
  end
end