defmodule TodaysPizzaWeb.PageController do
  use TodaysPizzaWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
