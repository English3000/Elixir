defmodule App0Web.HelloController do
  use App0Web, :controller
  # All controller actions take 2 arg's.
  # `conn` is a struct which holds data about the request.
  def index(conn, _params) do
    render conn, "index.html" # can replace w/ :index
    # looks for template `index.html.eex` in `/lib/app_0_web/templates/hello`

    #json conn, %{id: id}
  end
  # It’s good to remember that the keys to the params map will always be strings, and that the equals sign does not represent assignment, but is instead a pattern match assertion.
  # destructure one param; `%{...} = params` for access to all params
  def show(conn, %{"messenger" => messenger}) do
    render conn, "show.html", messenger: messenger
  end
end
