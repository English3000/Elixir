defmodule HackernewsWeb.Resolvers.Accounts do
  alias Hackernews.Accounts

  def sign_in(_, %{email: email, password: pw}, _) do
    case Accounts.authenticate(email, pw) do
      {:ok, user} -> token = HackernewsWeb.TokenAuth.sign(%{id: user.id})
                       {:ok, %{token: token, user: user}}
                _ -> {:error, "incorrect email/password"}
    end
  end

  def me(_,_, %{context: %{current_user: current_user}}), do: {:ok, current_user}
  def me(_,_,_),                                          do: {:ok, nil}

  def list_links(_,_,_), do: {:ok, Accounts.list_links()}

  def create_link(_, %{input: params}, _) do
    with {:ok, link} <- Accounts.create_link(params) do
      {:ok, %{link: link}}
    end
  end
end
