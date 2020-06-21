defmodule TodaysPizzaWeb.PageController do
  use TodaysPizzaWeb, :controller

  def cheeseboard_url do
    "https://cheeseboardcollective.coop/pizza/"
  end

  def extract_dates_and_toppings([date, pizza]) do
    # Expected format:
    #[
    #  {"p", [], ["Wed Jun 24"]},
    #  {"p", [],
    #    [
    #      "***This week we are offering partially baked pizzas to finish cooking at home. There are limited vegan, gluten-free friendly, and vegan+gluten-free friendly pizzas available also***",
    #      {"br", [], []},
    #      {"br", [], []},
    #      "Artichoke, kalamata olive, fresh ricotta made in Berkeley by Belfiore, mozzarella cheese, and house made tomato sauce"
    #    ]
    #  }
    #]
    # => ["Wed Jun 24", "Artichoke, kalamata olive, ..."]
    [
      elem(date, 2),
      elem(pizza, 2) |> List.last
    ]
  end

  def index(conn, _params) do
    html = HTTPoison.get!( cheeseboard_url() ).body
    {:ok, document} = Floki.parse_document(html)
    pizza_days = Floki.find(document, ".pizza-list") |> Floki.find("article") |> Floki.find("p")
    dates_and_toppings = Enum.chunk_every(pizza_days, 2, 2)
                         |> Enum.map( &extract_dates_and_toppings(&1) )

    render(conn, "index.html", %{dates_and_toppings: dates_and_toppings})
  end
end
