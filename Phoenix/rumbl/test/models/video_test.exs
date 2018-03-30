defmodule Rumbl.VideoTest do
  use Rumbl.ModelCase

  alias Rumbl.Video

  @valid_attrs %{description: "some description", title: "some title", url: "some url"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Video.changeset(%Video{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Video.changeset(%Video{}, @invalid_attrs)
    refute changeset.valid?
  end
end
