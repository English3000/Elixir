defmodule IslandsEngine.Game.Rules do  # TODO: major refactor
  alias __MODULE__                     # change to Player module?
  defstruct stage: :init, # game stage
            # players' stage
            player1: :init,
            player2: :init

  def new, do: %Rules{} # for consistent API across data structures..?

  def check(%Rules{stage: :init} = rules, :add_player),
    do: { :ok, %Rules{rules | stage: :players_set} }
  # def check(%Rules{} = rules, :add_player) do
  #   cond do
  #     rules.player1 == :none -> {:ok, %Rules{rules | player1: :joined} }
  #     rules.player2 == :none ->
  #                       true -> :error
  #   end
  # end

  def check(%Rules{stage: :players_set} = rules, {:place_islands, player}) do
    case Map.fetch!(rules, player) do
             :init -> {:ok, rules}
      :islands_set -> :error
    end
  end
  def check(%Rules{stage: :players_set} = rules, {:islands_set, player}) do
    rules = Map.put(rules, player, :islands_set)
    case ready?(rules) do
       true -> {:ok, %Rules{ rules | stage: {:turn, :player1} } }
      false -> {:ok, rules}
    end
  end

  def check(%Rules{stage: {:turn, player}} = rules, {:guess, guesser}) when guesser == player,
    do: { :ok, %Rules{rules | stage: {:turn, opponent(player)}} }
  def check(%Rules{stage: {:turn, _}} = rules, {:status, result}) do
    case result do
       true -> {:ok, %Rules{rules | stage: :end}}
      false -> {:ok, rules}
    end
  end

  def check(_state, _action), do: :error

  @doc "Get atom for opposing player. (Assumes only 2 players.)"
  def opponent(:player1), do: :player2
  def opponent(:player2), do: :player1

  defp ready?(rules), do: rules.player1 == :islands_set and
                          rules.player2 == :islands_set
end
