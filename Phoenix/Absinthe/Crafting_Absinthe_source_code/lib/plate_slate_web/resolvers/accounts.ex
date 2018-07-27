defmodule PlateSlateWeb.Resolvers.Accounts do
  alias PlateSlate.Accounts

  def sign_in(_, %{email: email, password: pw, role: role}, _) do
    case Accounts.authenticate(role, email, pw) do
      {:ok, user} ->
        token = PlateSlateWeb.Authentication.sign(%{role: role, id: user.id})
        {:ok, %{token: token, user: user}}
                _ -> {:error, "incorrect email or password"}
    end
  end

  def me(_,_, %{context: %{current_user: current_user}}), do: {:ok, current_user}
  def me(_,_,_),                                          do: {:ok, nil}
end
