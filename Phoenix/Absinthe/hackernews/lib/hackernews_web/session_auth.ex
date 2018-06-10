defmodule HackernewsWeb.SessionAuth do
  @behaviour Plug
  import Plug.Conn

  def init(options), do: options

  def call(conn, _) do
    unless get_session(conn, :current_user) do
      conn |> clear_session |> Phoenix.Controller.redirect(to: "/")
    end
  end
end
