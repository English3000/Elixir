defmodule VueWeb.PageController do
  use VueWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
