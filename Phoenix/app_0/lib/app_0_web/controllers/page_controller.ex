defmodule App0Web.PageController do
  use App0Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
