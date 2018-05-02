defmodule HackernewsWeb.Context do
  @behaviour Plug
  import Plug.Conn

  def init(options), do: options

  def call(conn, _) do
    context = build_context(conn)
    IO.inspect [context: context] #
    Absinthe.Plug.put_options(conn, context: context)
  end

  defp build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
                  {:ok, data} <- HackernewsWeb.TokenAuth.verify(token),
                   %{} = user <- Hackernews.Accounts.get_user!(data[:id]) do
      %{current_user: user}
    else
      _ -> %{}
    end
  end
end
