defmodule IslandsEngine.Game.Rules do
  alias __MODULE__
  defstruct state: :init,
            player1: :init,
            player2: :init

  def new, do: %Rules{} # seems redundant

  def check(%Rules{state: :init} = rules, :add_player),
    do: { :ok, %Rules{rules | state: :has_players} }

  def check(%Rules{state: :has_players} = rules, {:place_islands, player}) do
    case Map.fetch!(rules, player) do
             :init -> {:ok, rules}
      :islands_set -> :error
    end
  end
  def check(%Rules{state: :has_players} = rules, {:islands_set, player}) do
    rules = Map.put(rules, player, :islands_set)
    case ready?(rules) do
       true -> {:ok, %Rules{ rules | state: {:turn, :player1} } }
      false -> {:ok, rules}
    end
  end

  def check(%Rules{state: {:turn, player}} = rules, {:guess, guesser}) when guesser == player,
    do: { :ok, %Rules{rules | state: {:turn, opponent(player)}} }
  def check(%Rules{state: {:turn, _}} = rules, {:status, result}) do
    case result do
       true -> {:ok, %Rules{rules | state: :end}}
      false -> {:ok, rules}
    end
  end

  defp opponent(:player1), do: :player2 # assuming only 2 players
  defp opponent(:player2), do: :player1

  def check(_state, _action), do: :error

  defp ready?(rules), do: rules.player1 == :islands_set and
                          rules.player2 == :islands_set
end
