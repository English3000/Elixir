defmodule HackernewsWeb.Context do
  @behaviour Plug
  import Plug.Conn

  def init(options), do: options

  def call(conn, _) do
    user = build_context(conn)
    # IO.inspect [context: user]
    conn |> Plug.Conn.assign(:current_user, user)
         |> Absinthe.Plug.put_options(context: %{current_user: user})
  end

  defp build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
                  {:ok, data} <- HackernewsWeb.TokenAuth.verify(token),
                   %{} = user <- Hackernews.Accounts.get_user!(data[:id]) do
      user
    else
      _ -> %{}
    end
  end
end
