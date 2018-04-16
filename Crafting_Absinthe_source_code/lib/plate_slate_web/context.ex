defmodule PlateSlateWeb.Context do
  @behaviour Plug
  import Plug.Conn

  def init(options), do: options

  def call(conn, _) do
    context = build_context(conn)
    IO.inspect [context: context]
    Absinthe.Plug.put_options(conn, context: context)
  end

  defp build_context(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization"),
                  {:ok, data} <- PlateSlateWeb.Authentication.verify(token),
                   %{} = user <- get_user(data) do
      %{current_user: user}
    else
      _ -> %{}
    end
  end

  defp get_user(%{id: id, role: role}) do
    PlateSlate.Accounts.lookup(role, id)
  end
end
