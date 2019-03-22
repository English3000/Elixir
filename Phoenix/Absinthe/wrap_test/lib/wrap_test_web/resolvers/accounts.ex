defmodule WrapTestWeb.Resolvers.Accounts do
  alias WrapTest.Accounts
  # queries
  def list_links(_,_,_), do: {:ok, Accounts.list_links()}
end
