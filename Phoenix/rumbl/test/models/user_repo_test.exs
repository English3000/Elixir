defmodule Rumbl.UserRepoTest do
  use Rumbl.ModelCase
  alias Rumbl.User

  @valid_attrs %{name: "Test User", username: "test"}

  test "converts `unique_constraint` on username to error" do
    insert_user(username: "test")
    changeset = User.changeset(%User{}, @valid_attrs)

    assert {:error, changeset} = Repo.insert(changeset)
    assert {:username, {"has already been taken", []}} in changeset.errors
  end
end
