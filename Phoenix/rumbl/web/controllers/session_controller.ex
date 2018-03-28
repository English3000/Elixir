defmodule Rumbl.SessionController do
  use Rumbl.Web, :controller

  def new(conn, _) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => %{"username" => u_name,
                                    "password" => pw}}) do
    case Rumbl.Auth.sign_in(conn, u_name, pw, repo: Repo) do
      {:error, _reason, conn} -> conn
        |> put_flash(:error, "Invalid credentials")
        |> render("new.html")
      {:ok, conn} -> conn
        |> put_flash(:info, "Welcome back!")
        |> redirect(to: page_path(conn, :index))
    end
  end

  def delete(conn, _) do
    conn
    |> Rumbl.Auth.sign_out()
    |> redirect(to: page_path(conn, :index))
  end
end
