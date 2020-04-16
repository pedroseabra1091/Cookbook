defmodule Cookbook.Restaurant do
  use Ecto.Schema

  alias Cookbook.{Chef, Repo, Restaurant}
  alias Ecto.Multi

  import Ecto.{Changeset, Query}

  require IEx

  schema "restaurants" do
    field :name, :string, null: false
    field :location, :string, null: false

    belongs_to :chef, Chef

    timestamps()
  end

  def add_new_restaurant() do
    chef = Repo.get_by!(Chef, name: "Gordon Ramsay")

    params = %{chef: chef, name: "Heaven's Kitchen", location: "Baltimore"}
    params |> insert()
  end

  def update_existing_restaurant(restaurant_name, params) do
    restaurant = Repo.one(with_name(restaurant_name))

    # the prefix in Restaurant.update needs to stay otherwise it will collide with Ecto's update
    restaurant
    |> Restaurant.update(params)
  end

  def with_name(name, query \\ __MODULE__), do: from q in query, where: q.name == ^name

  def insert(params \\ %{}) do
    %Restaurant{}
    |> changeset(params)
    |> Repo.insert()
  end

  def update(restaurant, params \\ %{}) do
    restaurant
    |> changeset(params)
    |> Repo.update()
  end

  def delete(restaurant) do
    restaurant
    |> Repo.delete()
  end

  def changeset(restaurant, %{chef: chef} = params) do
    restaurant
    |> cast_and_validate(params)
    |> put_assoc(:chef, chef)
  end

  def changeset(restaurant, params) do
    restaurant
    |> cast_and_validate(params)
  end

  def cast_and_validate(restaurant, params) do
    restaurant
    |> cast(params, ~w(name location)a)
    |> validate_required(~w(name location)a)
    |> validate_length(:name, min: 3)
  end
end