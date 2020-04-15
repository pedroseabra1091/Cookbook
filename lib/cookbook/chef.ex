defmodule Cookbook.Chef do
  use Ecto.Schema

  alias Cookbook.{Chef, Recipe, Repo, Restaurant}

  import Ecto.{Changeset, Query}

  schema "chefs" do
    field :name, :string, null: false

    has_many :restaurants, Restaurant, on_delete: :delete_all
    has_many :recipes, Recipe, on_delete: :delete_all

    timestamps()
  end

  def with_name(name, query \\ __MODULE__), do: from q in query, where: q.name == ^name

  def insert(params \\ %{}) do
    %Chef{}
    |> changeset(params)
    |> Repo.insert!()
  end

  def update(chef, params \\ %{}) do
    chef
    |> Repo.preload([:restaurants, :recipes])
    |> changeset(params)
    |> Repo.update!()
  end

  def changeset(chef, params) do
    chef
    |> cast(params, ~w(name)a)
    |> validate_required(~w(name)a)
    |> cast_assoc(:restaurants, with: &Restaurant.changeset/2)
    |> cast_assoc(:recipes, with: &Recipe.changeset/2)
  end
end