defmodule Rumbl.Auth do
  import Plug.Conn
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]

  def init(options) do
    # as in Keyword List
    Keyword.fetch!(options, :repo)
  end

  def call(conn, repo) do
    user_id = get_session(conn, :user_id)
    user = user_id && repo.get(Rumbl.User, user_id)
    assign(conn, :current_user, user)
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
