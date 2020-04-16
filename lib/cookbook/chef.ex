defmodule Cookbook.Chef do
  use Ecto.Schema

  alias Cookbook.{Chef, Recipe, Repo, Restaurant}

  import Ecto.{Changeset, Query}

  require IEx

  schema "chefs" do
    field :name, :string, null: false

    has_many :restaurants, Restaurant, on_delete: :delete_all
    has_many :recipes, Recipe, on_delete: :delete_all

    timestamps()
  end

  def with_name(query, name), do: from q in query, where: q.name == ^name

  def insert_whole_association() do
    params = %{
      name: "Gordon Ramsay",
      restaurants: [
        %{name: "Hell's Kitchen", location: "LA"},
        %{name: "Gordon Steak house", location: "LA"},
      ],
      recipes: [
        %{
          name: "scrambled eggs",
          steps: [
            "BEAT eggs, milk, salt and pepper in medium bowl until blended",
            "HEAT butter in large nonstick skillet over medium heat until hot. POUR in egg mixture. As eggs begin to set, gently PULL the eggs across the pan with a spatula, forming large soft curds.",
            "CONTINUE cooking—pulling, lifting and folding eggs—until thickened and no visible liquid egg remains. Do not stir constantly. REMOVE from heat. SERVE immediately."
          ],
          category: "vegetarian",
          portions: 4,
          cooking_time: 10
        }
      ]
    }

    params |> insert()
  end

  def insert(params \\ %{}) do
    %Chef{}
    |> changeset(params)
    |> Repo.insert()
  end

  def update(chef, params \\ %{}) do
    chef
    |> Repo.preload(:restaurants)
    |> changeset(params)
    |> Repo.update()
  end

  def delete(chef) do
    chef
    |> Repo.delete()
  end

  def changeset(chef, params) do
    chef
    |> cast(params, ~w(name)a)
    |> validate_required(~w(name)a)
    |> cast_assoc(:restaurants, with: &Restaurant.changeset/2)
    |> cast_assoc(:recipes, with: &Recipe.bulk_changeset/2)
  end
end