defmodule Mix.Tasks.Seeds do
  use Mix.Task

  alias Cookbook.Chef

  require IEx

  def run(_) do
    start_repo()
    Enum.each(seeds_data(), &(Chef.insert(&1)))
  end

  defp start_repo, do: Mix.Task.run("app.start")


  defp seeds_data do
    [
      %{
        name: "Henrique Sá Pessoa",
        recipes: [
          %{
            name: "rabbit stew",
            steps: [
              "Joint the rabbits into pieces: the shoulders, ribs, loins and hind legs. Season all of the pieces with salt and pepper and lightly dust with a little flour", "Sauté the rabbit pieces all over in a frying pan over a high heat with a little olive oil. When golden-brown, set the rabbit to one side and discard the oil from the pan", "Pour in some more extra virgin olive oil and add the garlic, shallots and chilli. Cook for a few minutes until the shallots are golden", "Place the pieces of rabbit in the pan again and deglaze with the white wine. After about 5 minutes, add the tomatoes and the vegetable stock", "Leave to cook over medium heat for about 20 minutes", "Add the herbs and continue to cook over high heat until you obtain a thick sauce, for about another 30 minutes", "Garnish with basil leaves and sprigs of rosemary and serve"
            ],
            cooking_time: 120,
            category: "meat",
            portions: 4,
            recipe_ingredients: [%{ingredient: %{name: "Garlic"}, quantity: 1}, %{ingredient: %{name: "Onion"}, quantity: 1}]
          }
        ]
      },
      %{
        name: "José Avillez",
        recipes: [
          %{
            name: "lasagna",
            steps: [
              "Start by making the sauce with ground beef, bell peppers, onions, and a combo of tomato sauce, tomato paste, and crushed tomatoes. The three kinds of tomatoes gives the sauce great depth of flavor.","Let this simmer while you boil the noodles and get the cheese ready.", "From there, it’s just an assembly job. A cup of meat sauce, a layer of noodles, more sauce, followed by a layer of cheese. Repeat until you have three layers and have used up all the ingredients.", "Bake until bubbly and you’re ready to eat!"
            ],
            cooking_time: 40,
            portions: 8,
            category: "meat",
            recipe_ingredients: [
              %{ingredient: %{name: "Garlic"}, quantity: 2}, %{ingredient: %{name: "Onion"}, quantity: 2}
            ]
          }
        ]
      },
      %{
        name: "Gordon Ramsay",
        recipes: [
          %{
            name: "roast beef with caramelised onion gravy",
            steps: [
              "Rub the garlic halves and thyme leaves all over the beef. Place the joint in a large dish, drizzle over the olive oil, then rub it into the meat all over. Cover and leave to marinate in the fridge for 1–2 days before you cook it (you don’t have to marinate the beef in advance, but it does make it super tasty! – see Tip). Take the beef out of the fridge about an hour before cooking, to let it come up to room temperature.", "Preheat the oven to 190°C/170°C fan/Gas 5.", "Preheat a dry frying pan until very hot, then sear the beef over a high heat until it’s coloured on all sides. Place the beef in a large, hob-proof roasting tray with the garlic halves and the thyme sprig and roast for about 45 minutes for medium rare (or until it reaches 45–47°C in the centre, if you have a meat thermometer). Add 10–12 minutes for medium (or until it reaches 55–60°C in the centre), or add about 20 minutes if you like it well done (or until it reaches 65–70°C in the centre).", "Transfer the beef to a warm platter, cover loosely with foil and leave to rest for at least 20 minutes, and anything up to 40 minutes, before serving.", "Meanwhile, to make the gravy, place the roasting tray over a low heat on the hob, add the onions to the juices in the tray and cook gently for about 20 minutes, stirring occasionally, until really soft and caramelised. Stir in the flour until combined, then whisk in the red wine, making sure there are no lumps. Bring to the boil, whisking, then bubble rapidly until the red wine has reduced by half. Stir in the hot stock, then cook over a medium heat for about 8 minutes, stirring occasionally, until reduced to a thick gravy.", "Carve the beef thinly and pour the gravy into a warm jug. Serve with Yorkshire Puddings and steamed chard."
            ],
            cooking_time: 40,
            portions: 8,
            category: "meat",
            recipe_ingredients: [
              %{ingredient: %{name: "Garlic"}, quantity: 3}, %{ingredient: %{name: "Onion"}, quantity: 3}
            ]
          }
        ]
      },
    ]
  end
end