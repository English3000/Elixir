defmodule Rumbl.UserController do
  use Rumbl.Web, :controller

  plug :authenticate when action in [:index, :show]

  alias Rumbl.User

  def index(conn, _params) do
    users = Repo.all(User) # accessible b/c aliased in web.ex
    render conn, "index.html", users: users
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get(User, id) #if no user, returns `nil`
    render conn, "show.html", user: user
  end

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.registration_changeset(%User{}, user_params)
    insertion = Repo.insert(changeset)
    # IO.puts inspect insertion
    case insertion do
      {:error, changeset} -> render(conn, "new.html", changeset: changeset) #w/ failed validations
        # for some reason, '/users/new' => '/users'; still w/ "new.html"
      {:ok, user} -> conn
        |> Rumbl.Auth.sign_up(user)
        |> put_flash(:info, "#{user.name} created!")
        |> redirect(to: user_path(conn, :index))
    end
  end

  defp authenticate(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "Please sign in.")
      |> redirect(to: page_path(conn, :index))
      |> halt() #b/c plugged in a pipeline
    end
  end
end
