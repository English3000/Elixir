defmodule Rumbl.Auth do
  import Plug.Conn
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
  import Phoenix.Controller #put_flash, redirect

  alias Rumbl.Router.Helpers
  # compiled
  def init(options) do
    # as in Keyword List
    Keyword.fetch!(options, :repo)
  end
  # runtime
  def call(conn, repo) do
    user_id = get_session(conn, :user_id)
    # added (except the middle cond) for testability = 'controversial'
    cond do
      user = conn.assigns[:current_user] -> conn
      user = user_id && repo.get(Rumbl.User, user_id) ->
        assign(conn, :current_user, user)
      true -> assign(conn, :current_user, nil)
    end
  end

  def authenticate_user(conn, _opts) do
    if conn.assigns.current_user do
      conn
    else
      conn
      |> put_flash(:error, "Please sign in.")
      |> redirect(to: Helpers.page_path(conn, :index))
      |> halt() #b/c plugged in a pipeline
    end
  end

  def sign_up(conn, user) do
    conn
    |> assign(:current_user, user)
    |> put_session(:user_id, user.id)
    # gen's a new session id for the cookie--protects from "session fixation" attacks
    |> configure_session(renew: true)
  end

  def sign_in(conn, u_name, pw, options) do
    repo = Keyword.fetch!(options, :repo)
    user = repo.get_by(Rumbl.User, username: u_name)

    cond do
      user && checkpw(pw, user.password_hash) -> {:ok, sign_up(conn, user)}
      user -> {:error, :unauthorized, conn}
      # simulates timing of checkpw to defend against "timing attacks"
      true -> dummy_checkpw(); {:error, :not_found, conn}
    end
  end

  def sign_out(conn) do
    configure_session(conn, drop: true)
    #if want to keep session:
    # delete_session(conn, :user_id)
  end
end
