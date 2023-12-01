require IEx

defmodule AdventWeb.PageController do
  use AdventWeb, :controller

  def index(conn, _params) do
    # IEx.pry
    render(conn, "index.html")
  end
end
