defmodule PlateSlate.Accounts do
  @moduledoc """
  The Accounts context
  """
  import Ecto.Query, warn: false
  alias PlateSlate.Repo
  alias PlateSlate.Accounts.User
  alias Comeonin.Ecto.Password

  def authenticate(role, email, pw) do
    user = Repo.get_by(User, role: to_string(role), email: email)

    with %{password: digest} <- user,
                        true <- Password.valid?(pw, digest) do
      {:ok, user}
    else
      _ -> :error
    end
  end

  def lookup(role, id), do: Repo.get_by(User, role: to_string(role), id: id)
end
