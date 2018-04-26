defmodule HackernewsWeb.Resolvers.Accounts do
  alias Hackernews.Accounts

  def list_links(_,_,_), do: {:ok, Accounts.list_links()}

  def create_link(_, %{input: params}, _) do
    with {:ok, link} <- Accounts.create_link(params) do
      {:ok, %{link: link}}
    end
  end
end
