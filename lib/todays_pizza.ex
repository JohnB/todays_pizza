defmodule TodaysPizza do
  @moduledoc """
  TodaysPizza keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  # Since the followers all know the drill, just
  # cut to the chase for whatever boilerplate.
  @partial_bake ~r/\*\*\*We will have partially baked pizzas available at the bakery from 9 a.m. to 4 p.m. or until we sell out./
  @full_bake ~r/Hot whole and half pizza \(no slices yet\) will be available at the pizzeria from 5 p.m. to 8 p.m or until we sell out/

  # This function is called by the Heroku scheduler (sorta cron).
  # Set this value in the Heroku scheduler UI
  #   mix run -e 'IO.puts TodaysPizza.tweet_about_pizza'
  #
  def tweet_about_pizza do
    ExTwitter.configure(
      consumer_key: System.get_env("consumer_key"),
      consumer_secret: System.get_env("consumer_secret"),
      access_token: System.get_env("oauth_token"),
      access_token_secret: System.get_env("oauth_token_secret")
    )

    try do
      ExTwitter.update(pizza_message())
    rescue
      _ -> ExTwitter.update("d @JohnB - something broke and needed rescuing.")
    catch
      err -> ExTwitter.update("d @JohnB caught #{err}.")
    end
  end

  def pizza_message_lines do
    pizza_message()
    |> String.split("\n")
    |> Enum.map(fn line -> String.trim(line) end)
  end

  def pizza_message do
    # NOTE: `h Timex.Format.DateTime.Formatters.Strftime` shows the format codes.
    # Try to match "Fri Jun 27" that we see from the cheeseboard site.
    # The name means: dow=DayOfWeek, mon=Month, day=DayOfMonth
    # Note: the timex formatting allows for "08" or " 8" but not just "8".
    now = Timex.now("PST")
    dow_mon_day = Timex.format!(now, "%a %b #{now.day}", :strftime)

    todays_pizza =
      fetch_dates_and_topping()
      |> Enum.find(fn [date, _message] ->
        #IO.inspect([date, _message])
        date == dow_mon_day
      end)

    case todays_pizza do
      nil -> "#{dow_mon_day}: So very sad. No pizza today."
      [_, message] -> "#{dow_mon_day}: #{trimmed_message(message)}"
      _ -> "d @JohnB Unexpected todays_pizza array: #{inspect(todays_pizza)}."
    end
  end

  def trimmed_message(message) do
    message = Regex.replace(@partial_bake, message,
      "Partially baked: 9 to 4 or until sold out.")
    message = Regex.replace(@full_bake, message,
      "\nHot whole or half (no slices): 5 to 8 or until sold out")
    message = Regex.replace(~r/\*\*\*/, message, "\n")
    message = Regex.replace(~r/we sell out/, message, "sold out")
    [boilerplate, topping] = String.split(message, ~r/\n\n\n/)

    "#{topping}.\n\n#{boilerplate}."
    |> String.slice(1, 279) # only 280 chars max
  end

  # TODO: update the return signature to include salad somehow
  # and then restore the salad tweets.
  def fetch_dates_and_topping do
    html = HTTPoison.get!(
      "https://cheeseboardcollective.coop/pizza/"
    ).body
    {:ok, document} = Floki.parse_document(html)

    pizza_articles = Floki.find(document, ".pizza-list") |>
      Floki.find("article")

    #pizza_article = List.first(pizza_articles)
    Enum.map(pizza_articles, fn pizza_article ->
      date = Floki.find(pizza_article, "div.date") |> Floki.text()
      menu = Floki.find(pizza_article, "div.menu")
      _titles = Floki.find(menu, "h3")
      topping_and_salad = Floki.find(menu, "p")
      topping = topping_and_salad |> List.first |> Floki.text
      #salad = topping_and_salad |> List.first |> Floki.text

      [
        date,
        topping,
        #salad,
      ]
    end)

    # For offline debugging, comment above and uncomment below.
    # @example_data_20200621
  end

  def cheeseboard_url do
    "https://cheeseboardcollective.coop/pizza/"
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
