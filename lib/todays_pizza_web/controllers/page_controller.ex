defmodule TodaysPizzaWeb.PageController do
  use TodaysPizzaWeb, :controller

  def index(conn, _params) do
    dates_and_toppings = TodaysPizza.fetch_dates_and_topping

    # static data option for debugging
    #    dates_and_toppings = @example_data_20200621

    render(conn, "index.html", %{dates_and_toppings: dates_and_toppings})
  end
end



