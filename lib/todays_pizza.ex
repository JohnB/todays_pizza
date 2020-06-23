defmodule TodaysPizza do
  @moduledoc """
  TodaysPizza keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  # We likely won't need this static test data very often
  # but I captured it so might as well use it.
  @example_data_20200621 [
    [
      "Tue Jun 23",
      "TEST DATA Shiitake mushroom, leek, mozzarella cheese, and sesame-citrus sauce"
    ],
    [
      "Wed Jun 24",
      "TEST DATA Artichoke, kalamata olive, fresh ricotta made in Berkeley by Belfiore, mozzarella cheese, and house made tomato sauce"
    ],
    [
      "Thu Jun 25",
      "TEST DATA Crushed tomato, red onion, cheddar cheese, mozzarella cheese, garlic olive oil, and cilantro"
    ],
    [
      "Fri Jun 26",
      "TEST DATA Peach, Dunbarton blue cheese, mozzarella cheese, and arugula dressed in lemon vinaigrette"
    ],
    [
      "Sat Jun 27",
      "TEST DATA A rainbow of mixed sweet bell peppers, red onion, mozzarella cheese, Ossau Iraty cheese, garlic olive oil, and Italian parsley"
    ]
  ]

  # Since the followers all know the drill, just cut to the chase for whatever
  # boilerplate
  @preface "(partially baked pizzas to finish cooking at home)\n"

  def pizza_message do
    # NOTE: `h Timex.Format.DateTime.Formatters.Strftime` shows the format codes.
    # Try to match "Fri Jun 27" that we see from the cheeseboard site.
    # The name means: dow=DayOfWeek, mon=Month, day=DayOfMonth
    dow_mon_day = Timex.format!(Timex.now, "%a %b %d", :strftime)

    todays_pizza = fetch_dates_and_topping()
                   |> Enum.find( fn [date, _message] -> date = dow_mon_day end)

    case todays_pizza do
      nil          -> "#{dow_mon_day}: Calamity! No pizza today."
      [_, message] -> "#{@preface} #{dow_mon_day}: #{message}"
      _            -> "d @JohnB Unexpected todays_pizza array: #{inspect(todays_pizza)}."
    end
  end

  def fetch_dates_and_topping do
    html = HTTPoison.get!( cheeseboard_url() ).body
    {:ok, document} = Floki.parse_document(html)
    pizza_days = Floki.find(document, ".pizza-list")
                 |> Floki.find("article")
                 |> Floki.find("p")

    Enum.chunk_every(pizza_days, 2, 2)
    |> Enum.map( &extract_dates_and_toppings(&1) )

    # For offline debugging
    #@example_data_20200621
  end

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
      elem(date, 2)  |> List.last,
      elem(pizza, 2) |> List.last
    ]
  end

end
