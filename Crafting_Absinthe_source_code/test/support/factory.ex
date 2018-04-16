defmodule Factory do
  alias PlateSlate.{Repo, Accounts}

  def create_user(role) do
       int = :erlang.unique_integer([:positive, :monotonic])
    params = %{ name: "Person #{int}",
                email: "fake#{int}@elixir-lang.org",
                password: "super-secret",
                role: role }

    %Accounts.User{}
    |> Accounts.User.changeset(params)
    |> Repo.insert!
  end
end
