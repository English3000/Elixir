defmodule Rumbl.AuthTest do
  use Rumbl.ConnCase
  alias Rumbl.Auth
  alias Rumbl.User

  @user_attrs %{username: "test", password: "testing"}

  setup %{conn: conn} do
    conn = conn
      |> bypass_through(Rumbl.Router, :browser)
      # stored in `conn` w/o routing
      |> get("/")

    {:ok, %{conn: conn}}
  end

  test "`call` places user from session into `conn.assigns`", %{conn: conn} do
    user = insert_user()

    conn = conn
      |> put_session(:user_id, user.id)
      |> Auth.call(Repo)

    assert conn.assigns.current_user.id == user.id
  end

  test "if no session, `call` places nil into `conn.assigns`", %{conn: conn} do
    conn = Auth.call(conn, Repo)
    assert conn.assigns.current_user == nil
  end

  test "`authenticate_user` halts if no `current_user`", %{conn: conn} do
    conn = Auth.authenticate_user(conn, [])
    assert conn.halted
  end

  test "`authenticate_user` works, given `current_user`", %{conn: conn} do
    conn = conn
      |> assign(:current_user, %User{})
      |> Auth.authenticate_user([])

    refute conn.halted
  end

  test "`sign_up` adds user to session", %{conn: conn} do
    sign_up_conn = conn
      |> Auth.sign_up(%User{id: 123})
      |> send_resp(:ok, "")

    next_conn = get(sign_up_conn, "/")

    assert get_session(next_conn, :user_id) == 123
  end

  test "`sign_in` w/ valid username & password", %{conn: conn} do
    user = insert_user(@user_attrs)

    {:ok, conn} = Auth.sign_in(conn, "test", "testing", repo: Repo)

    assert conn.assigns.current_user.id == user.id
  end

  test "`sign_in` fails if username not found", %{conn: conn} do
    assert {:error, :not_found, _conn} =
      Auth.sign_in(conn, "test", "testing", repo: Repo)
  end

  test "`sign_in` fails w/ wrong password", %{conn: conn} do
    _ = insert_user(@user_attrs)

    assert {:error, :unauthorized, _conn} =
      Auth.sign_in(conn, "test", "wrong", repo: Repo)
  end

  test "`sign_out` drops session", %{conn: conn} do
    sign_out_conn = conn
      |> put_session(:user_id, 123)
      |> Auth.sign_out()
      |> send_resp(:ok, "")

    next_conn = get(sign_out_conn, "/")

    refute get_session(next_conn, :user_id) == 123
  end
end
