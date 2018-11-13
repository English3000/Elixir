defmodule IslandsInterfaceWeb.GameChannelTest do
  use IslandsInterfaceWeb.ChannelCase, async: true

  alias IslandsInterfaceWeb.{GameChannel, UserSocket}
  alias IslandsEngine.Game.Server

  describe ".join/3 [INTEGRATION TEST]" do
    @game "TEST"
    @player "works"
    test "works" do
      IO.write "\nIslandsInterfaceWeb.GameChannel "

      {:ok, result, socket} = subscribe_and_join(
        socket(UserSocket), GameChannel, "game:" <> @game, %{"screen_name" => @player}
      )

      assert result == %{game: @game, player: @player}
                       |> Server.new_game()
                       |> update_in([:player2], &Map.delete(&1, :islands))

      assert_broadcast "game_joined", %{} # not testing for payload match
    end

    test "allows only 2 players per game" do
      #
    end
  end
end
