defmodule Rumbl.Channels.VideoChannelTest do
  use Rumbl.ChannelCase
  import Rumbl.TestHelpers

  setup do
    user = insert_user(name: "Rebecca")
    video = insert_video(user, title: "Testing")
    token = Phoenix.Token.sign(@endpoint, "user socket", user.id)
    # Receives the socket params and authenticates the connection.
    # Simulates socket connection.
    # (https://hexdocs.pm/phoenix/Phoenix.Socket.html#c:connect/2)
    {:ok, socket} = connect(Rumbl.UserSocket, %{"token" => token})
    {:ok, socket: socket, user: user, video: video}
  end

  test "join replies w/ video annotations", %{socket: socket, video: video} do
    for body <- ~w(one two) do
      video |> build_assoc(:annotations, %{body: body})
            |> Repo.insert!()
    end
    # attempt to join the channel responsible for the "video:#{vid.id}" topic.
    {:ok, reply, socket} = subscribe_and_join(socket, "videos:#{video.id}", %{})

    assert socket.assigns.video_id = video.id
    assert reply == %{annotations: [%{body: "one"}, %{body: "two"}]}
  end

  test "inserting new annotations", %{socket: socket, video: video} do
    {:ok, _, socket} = subscribe_and_join(socket, "videos:#{video.id}", %{})
    # push event to channel
    ref = push socket, "new_annotation", %{body: "body", at: 0}

    assert_reply ref, :ok, %{}
    assert_broadcast "new_annotation", %{}
  end

  test "new annotations triggers InfoSys", %{socket: socket, video: video} do
    insert_user(username: "wolfram")

    {:ok, _, socket} = subscribe_and_join(socket, "videos:#{video.id}", %{})

    ref = push socket, "new_annotation", %{body: "1 + 1", at: 123}

    assert_reply ref, :ok, %{}
    assert_broadcast "new_annotation", %{body: "1 + 1", at: 123}
    assert_broadcast "new_annotation", %{body: "2", at: 123}
  end
end
