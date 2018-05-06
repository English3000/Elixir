defmodule HackernewsWeb.SessionAuth do
  @behaviour Plug
  import Plug.Conn

  def init(options), do: options

  def call(conn, _) do
    with id when not is_nil(id) <- get_session(conn, :current_user_id), #adjust?
                     %{} = user <-  Hackernews.Accounts.get_user!(id) do
      conn |> Plug.Conn.assign(:current_user, user)
           |> Absinthe.Plug.put_options(context: %{current_user: user})
    else
      _ -> conn |> clear_session |> Phoenix.Controller.redirect(to: "/")
    end
  end
end
