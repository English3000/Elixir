defmodule IslandsInterfaceWeb.GameChannelTest do
  use IslandsInterfaceWeb.ChannelCase, async: true

  alias IslandsInterfaceWeb.{GameChannel, UserSocket}
  alias IslandsEngine.Game.Server

  defp join_(game, player),
    do: socket(UserSocket)
        |> subscribe_and_join(GameChannel, "game:" <> game, %{"screen_name" => player})

  IO.write "IslandsInterfaceWeb.GameChannel\n"

  describe ".join/3 [INTEGRATION TEST]" do
    @game1 "game1"
    @player1 "player1"
    test "works" do

      {:ok, result, _socket} = join_(@game1, @player1)

      assert result == %{game: @game1, player: @player1}
                       |> Server.new_game()
                       |> update_in([:player2], &Map.delete(&1, :islands))

      assert_broadcast "game_joined", %{} # not testing for payload match
    end

    @game2 "game2"
    @player2 "player2"
    @player3 "player3"
    test "allows only 2 players per game" do
      {:ok, _result, _socket}       = join_(@game2, @player1)
      {:ok, _result, _socket}       = join_(@game2, @player2)
      { :error, %{reason: reason} } = join_(@game2, @player3)

      assert String.contains?(reason, [@player1, @player2])
    end

    @game3 "game3"
    test "prevents 2 people from joining game as same player" do
      {:ok, _result, _socket}       = join_(@game3, @player1)
      { :error, %{reason: reason} } = join_(@game3, @player1)

      assert String.contains?(reason, @player1)
    end
  end

  # NOTE: Can't test `join/3` helpers b/c using `GameChannel` directly =>
  # `** (FunctionClauseError) no function clause matching in Phoenix.Tracker.track/5`

  # Can add tests for `handle_in/3` events, if run into bugs there.
end
