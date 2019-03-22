defmodule WrapTestWeb.PageController do
  use WrapTestWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
