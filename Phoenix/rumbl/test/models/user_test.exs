defmodule Rumbl.UserTest do
  use Rumbl.ModelCase, async: true #side effect -free, so won't use db
  alias Rumbl.User

  @valid_attrs %{name: "Test User", username: "test", password: "testing"}
  @invalid_attrs %{}

  test "`changeset` w/ valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "`changeset` w/ invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "`changeset` rejects too long usernames" do
    attrs = Map.put(@valid_attrs, :username, String.duplicate("a", 30))
    assert {:username, "should be at most 20 character(s)"}
      in errors_on(%User{}, attrs)
  end

  test "`registration_changeset` password length enforced" do
    attrs = Map.put(@valid_attrs, :password, "12345")
    changeset = User.registration_changeset(%User{}, attrs)

    assert {:password, {"should be at least %{count} character(s)", [count: 6, validation: :length, min: 6]}}
      in changeset.errors
  end

  test "`registration_changeset` hashes valid password" do
    changeset = User.registration_changeset(%User{}, @valid_attrs)
    %{password: pw, password_hash: hash} = changeset.changes

    assert changeset.valid?
    assert hash
    assert Comeonin.Bcrypt.checkpw(pw, hash)
  end
end
