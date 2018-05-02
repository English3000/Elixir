defmodule HackernewsWeb.Resolvers.Accounts do
  alias Hackernews.Accounts
  # queries
  def me(_,_, %{context: %{current_user: current_user}}), do: {:ok, current_user}
  def me(_,_,_),                                          do: {:ok, nil}

  def list_links(_,_,_), do: {:ok, Accounts.list_links()}

  def create_link(_, %{input: params}, _) do
    with {:ok, link} <- Accounts.create_link(params) do
      {:ok, %{link: link}}
    end
  end

  # mutations
  def sign_up(_, args, _) do
    with {:ok, user} <- Accounts.create_user(args), do: generate_token(%{id: user.id})
  end

  def sign_in(_, %{email: email, password: pw}, _) do
    with {:ok, user} <- Accounts.authenticate(email, pw) do
      generate_token(%{id: user.id})
    else #if fails, `commitMutation`'s `onError` callback is triggered
      _ -> {:error, "incorrect email/password"}
    end
  end

  defp generate_token(data) do
    token = HackernewsWeb.TokenAuth.sign(data)
    {:ok, %{token: token, user: user}}
  end
end
