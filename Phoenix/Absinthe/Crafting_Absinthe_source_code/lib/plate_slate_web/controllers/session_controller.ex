defmodule PlateSlateWeb.SessionController do
  use PlateSlateWeb, :controller
  use Absinthe.Phoenix.Controller, schema: PlateSlateWeb.Schema

  def new(conn, _), do: render(conn, "new.html")

  @graphql """
  mutation ($email: String!, $password: String!) @action(mode: INTERNAL) {
    sign_in(role: EMPLOYEE, email: $email, password: $password)
  }
  """
  def create(conn, %{data: %{sign_in: result}}) do
    case result do
      %{user: employee} -> conn |> put_session(:employee_id, employee.id)
                                |> put_flash(:info, "Signed in!")
                                |> redirect(to: "/admin/items")

                      _ -> conn |> put_flash(:info, "Wrong email or password")
                                |> render("new.html")
    end
  end

  def delete(conn, _),
    do: conn |> clear_session |> redirect(to: "/admin/session/new")
end
