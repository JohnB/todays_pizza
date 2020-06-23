defmodule TodaysPizza do
  @moduledoc """
  TodaysPizza keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  # Since the followers all know the drill, just cut to the chase for whatever
  # boilerplate
  @message_from_the_collective "\n(partially baked pizza to finish cooking at home)"

  def tweet_about_pizza do
    ExTwitter.configure([
      consumer_key: System.get_env("consumer_key"),
      consumer_secret: System.get_env("consumer_secret"),
      access_token: System.get_env("oauth_token"),
      access_token_secret: System.get_env("oauth_token_secret"),
    ])
    ExTwitter.update(pizza_message)
  end

  def pizza_message do
    # NOTE: `h Timex.Format.DateTime.Formatters.Strftime` shows the format codes.
    # Try to match "Fri Jun 27" that we see from the cheeseboard site.
    # The name means: dow=DayOfWeek, mon=Month, day=DayOfMonth
    dow_mon_day = Timex.format!(Timex.now, "%a %b %d", :strftime)

    todays_pizza = fetch_dates_and_topping()
                   |> Enum.find( fn [date, _message] -> date = dow_mon_day end)

    case todays_pizza do
      nil          -> "#{dow_mon_day}: Calamity! No pizza today."
      [_, message] -> "#{dow_mon_day}: #{message}#{@message_from_the_collective}"
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

    # For offline debugging, comment above and uncomment below.
    #@example_data_20200621
  end

  def cheeseboard_url do
    "https://cheeseboardcollective.coop/pizza/"
  end

  # NOTE: This function will break when they next change the site.
  # Not much we can do about it until it happens.
  def extract_dates_and_toppings([date, pizza]) do
    # Expected format:
    #[
    #  {"p", [],
    #    ["Wed Jun 24"]
    #  },
    #  {"p", [],
    #    [
    #      "***This week we are offering partially baked pizzas to finish cooking at home. There are limited vegan, gluten-free friendly, and vegan+gluten-free friendly pizzas available also***",
    #      {"br", [], []},
    #      {"br", [], []},
    #      " Artichoke, kalamata olive, fresh ricotta made in Berkeley by Belfiore, mozzarella cheese, and house made tomato sauce"
    #    ]
    #  }
    #]
    # => ["Wed Jun 24", "Artichoke, kalamata olive, ..."]
    [
      elem(date, 2)  |> List.last |> String.trim,
      elem(pizza, 2) |> List.last |> String.trim
    ]
  end

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
end
