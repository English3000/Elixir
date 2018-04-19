defmodule Rumbl.Channels.UserSocketTest do
  use Rumbl.ChannelCase, async: true
  alias Rumbl.UserSocket

  test "socket auth w/ valid token" do
    # `@endpoint` from channel_case.ex
    token = Phoenix.Token.sign(@endpoint, "user socket", "123")

    assert {:ok, socket} = connect(UserSocket, %{"token" => token})
    assert socket.assigns.user_id == "123"
  end

  test "socket auth w/ invalid token" do
    assert :error = connect(UserSocket, %{"token" => "1313"})
    assert :error = connect(UserSocket, %{})
  end
end
