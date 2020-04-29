defmodule Mix.Tasks.Seeds do
  use Mix.Task

  alias Cookbook.{Chef, Page, Recipe, Repo}

  require IEx

  def run(_) do
    start_repo()

    # Transactions with functions
    # classic_transaction()

    # Non-transaction nested association approach
    # nested_association_approach()

    # Transactions with Ecto.Multi
    # multi_approach()

    # Transactions with Ecto.Multi, however validations are made at the embedded schema
    multi_approach_with_prior_validation()
  end

  defp start_repo, do: Mix.Task.run("app.start")

  def classic_transaction do
    recipe = %{
      name: 1,
      steps: [
        "BEAT eggs, milk, salt and pepper in medium bowl until blended.", "HEAT butter in large nonstick skillet over medium heat until hot. POUR in egg mixture. As eggs begin to set, gently PULL the eggs across the pan with a spatula, forming large soft curds.", "CONTINUE cooking—pulling, lifting and folding eggs—until thickened and no visible liquid egg remains. Do not stir constantly. REMOVE from heat. SERVE immediately."
      ],
      category: "vegetarian",
      portions: 2,
      cooking_time: 5
    }

    Repo.transaction(fn ->
      case Chef.insert(%{name: "Gordon"}) do
        {:ok, chef} -> Recipe.insert!(Map.merge(recipe, %{chef: chef}))
        {:error, _changeset} -> Repo.rollback(:failed_to_create_chef)
      end
    end)
  end

  defp nested_association_approach, do: Enum.each(nested_data(), &(Chef.insert(&1)))

  # Changesets are performed in the respective schemas
  defp multi_approach do
    case Repo.transaction(Page.to_multi(multi_data())) do
      {:ok, _committed_changes} ->
        IO.puts("Success on all 4 operations!")
      {:error, failed_operation, _failed_value, _changes} ->
        IO.puts("#{failed_operation} failed")
    end
  end

  # Changesets are checked in the embedded schema
  defp multi_approach_with_prior_validation do
    changeset = Page.changeset(%Page{}, multi_data())

    if changeset.valid? do
      multi_approach()
    else
      IO.inspect changeset
    end
  end

  defp nested_data do
    [
      %{
        name: "Henrique Sá Pessoa",
        recipes: [
          %{
            steps: [
              "Season the rabbit legs with salt and pepper then coat them in the flour. Shake off the excess flour and set it aside for later use", "Put the butter and oil into a large heavy-bottomed pan over a medium heat and when the butter has melted and the oil is hot, add the rabbit legs (in batches if necessary – the meat should sear, not steam). Brown the legs on all sides then remove from the pan and set aside", "Add the onion, celery and mushrooms to the pan and cook until soft and beginning to caramelize.", "Stir in the reserved flour and add enough wine to deglaze the pan. Return the rabbit legs and add the rest of the wine, the chicken stock and the thyme making sure the legs are submerged.", "Bring to the boil then reduce to a simmer, cover and cook on the hob for 60–70 minutes until the rabbit is tender. After 30 minutes, remove the lid to allow the liquid to reduce."
            ],
            cooking_time: 120,
            category: "meat",
            portions: 4,
            recipe_ingredients: [
              %{ingredient: %{name: "Rabbit Leg"}, quantity: 4},
              %{ingredient: %{name: "Mushroom"}, quantity: 200},
              %{ingredient: %{name: "Thyme"}, quantity: 1}
            ]
          }
        ]
      },
      %{
        name: "José Avillez",
        recipes: [
          %{
            name: "Lasagna",
            steps: [
              "Preheat oven to 375º. In a large pot of salted boiling water, cook pasta according to package directions until al dente, less 2 minutes. Drain and drizzle a bit of olive oil to prevent noodles from sticking together.", "Meanwhile, in a large pot over medium-high heat, heat oil. Cook ground beef until no longer pink, breaking up with a wooden spoon. Remove from heat and drain fat. Return beef to skillet and add garlic and oregano and cook, stirring, for 1 minute. Season with salt and pepper, then add marinara and stir until warmed through.", "Combine ricotta, 1/4 cup Parmesan, parsley, and egg in a large mixing bowl and season with salt and pepper. Set aside.", "In a large casserole dish, evenly spread a quarter of the meat sauce across the bottom of the dish, then top with a single layer of lasagna noodles, a layer of ricotta mixture, and a single layer of mozzarella. Repeat layers, topping the last layer of noodles with meat sauce, Parmesan, and mozzarella.", "Cover with foil and bake for 15 minutes, then increase temperature to 400º and bake uncovered for 18 to 20 minutes.", "Garnish with parsley before serving."
            ],
            cooking_time: 75,
            portions: 8,
            category: "meat",
            recipe_ingredients: [
              %{ingredient: %{name: "lasagna noodles"}, quantity: 3},
              %{ingredient: %{name: "ground beef"}, quantity: 2},
              %{ingredient: %{name: "garlic"}, quantity: 4},
              %{ingredient: %{name: "marinana"}, quantity: 2},
              %{ingredient: %{name: "milk ricotta"}, quantity: 16},
              %{ingredient: %{name: "parmesan"}, quantity: 1},
              %{ingredient: %{name: "parsley"}, quantity: 10},
              %{ingredient: %{name: "egg"}, quantity: 1},
              %{ingredient: %{name: "mozzarella"}, quantity: 2},
            ]
          }
        ]
      }
    ]
  end

  defp multi_data do
    %{
      chef_name: "Henrique Sá Pessoa",
      recipe_name: "Rabbit stew",
      steps: [
        "Season the rabbit legs with salt and pepper then coat them in the flour. Shake off the excess flour and set it aside for later use", "Put the butter and oil into a large heavy-bottomed pan over a medium heat and when the butter has melted and the oil is hot, add the rabbit legs (in batches if necessary – the meat should sear, not steam). Brown the legs on all sides then remove from the pan and set aside", "Add the onion, celery and mushrooms to the pan and cook until soft and beginning to caramelize.", "Stir in the reserved flour and add enough wine to deglaze the pan. Return the rabbit legs and add the rest of the wine, the chicken stock and the thyme making sure the legs are submerged.", "Bring to the boil then reduce to a simmer, cover and cook on the hob for 60–70 minutes until the rabbit is tender. After 30 minutes, remove the lid to allow the liquid to reduce."
      ],
      cooking_time: 120,
      category: "meat",
      portions: 4,
      ingredients: [
        %{name: "rabbit leg"},
        %{name: "mushroom"},
        %{name: "thyme"}
      ],
      quantity: [1, 200, 1]
    }
  end
end