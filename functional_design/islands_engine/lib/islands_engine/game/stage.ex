defmodule IslandsEngine.Game.Stage do
  alias __MODULE__
  alias IslandsEngine.DataStructures.Player

  def check(%Player{stage: :none} = player, {:add_player, name}),
    do: { :ok, %Player{player | name: name, stage: :joined} }
  def check(%Player{stage: :joined}, :place_island),
    do: :ok
  def check(%Player{stage: :joined} = player, :set_islands),
    do: { :ok, %Player{player | stage: :ready} }
  def check(%Player{stage: :ready} = player1, %Player{stage: :ready} = player2),
    do: { :ok, %Player{player1 | stage: :turn}, %Player{player2 | stage: :wait} }
  def check(%Player{stage: :turn} = guesser, waiting, status) do
    case status do
       true -> { :ok, %Player{guesser | stage: :won},  %Player{waiting | stage: :lost} }
      false -> { :ok, %Player{guesser | stage: :wait}, %Player{waiting | stage: :turn} }
    end
  end
  def check(_state, _action),          do: :error
  def check(_state, _action, _status), do: :error


  # def check(%Stage{stage: :init} = rules, :add_player),
  #   do: { :ok, %Stage{rules | stage: :players_set} }
  #
  # def check(%Stage{stage: :players_set} = rules, {:place_islands, player}) do
  #   case Map.fetch!(rules, player) do
  #            :init -> {:ok, rules}
  #     :islands_set -> :error
  #   end
  # end
  # def check(%Stage{stage: :players_set} = rules, {:islands_set, player}) do
  #   rules = Map.put(rules, player, :islands_set)
  #   case ready?(rules) do
  #      true -> {:ok, %Stage{ rules | stage: {:turn, :player1} } }
  #     false -> {:ok, rules}
  #   end
  # end
  #
  # def check(%Stage{stage: {:turn, player}} = rules, {:guess, guesser}) when guesser == player,
  #   do: { :ok, %Stage{rules | stage: {:turn, opponent(player)}} }
  # def check(%Stage{stage: {:turn, _}} = rules, {:status, result}) do
  #   case result do
  #      true -> {:ok, %Stage{rules | stage: :end}}
  #     false -> {:ok, rules}
  #   end
  # end
  #
  # def check(_state, _action), do: :error
  #
  # defp ready?(rules), do: rules.player1 == :islands_set and
  #                         rules.player2 == :islands_set
end
