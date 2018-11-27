defmodule Tournament do
  @doc """
  Given `input` lines representing two teams and whether the first of them won,
  lost, or reached a draw, separated by semicolons, calculate the statistics
  for each team's number of games played, won, drawn, lost, and total points
  for the season, and return a nicely-formatted string table.

  A win earns a team 3 points, a draw earns 1 point, and a loss earns nothing.

  Order the outcome by most total points for the season, and settle ties by
  listing the teams in alphabetical order.
  """
  defmodule Stats do
    defstruct [
      matches_played: 0,
      win:            0,
      draw:           0,
      loss:           0,
      points:         0
    ]

    @type t :: %Stats{
      win:            non_neg_integer,
      draw:           non_neg_integer,
      loss:           non_neg_integer,
      matches_played: non_neg_integer,
      points:         non_neg_integer
    }
  end
  @spec tally(input :: [String.t]) :: %{name :: String.t => Stats.t}
  def tally(input), do: IO.inspect(input) #tabulate(%{}, input)

  defp tabulate(teams, []), do: calculate(teams)
  defp tabulate(teams, [head | tail]) do
    [team, opp, result] = String.split(head, ";")

    stats = teams
            |> Map.get(team, %Stats{})
            |> Map.update( String.to_atom(result), 1, &(&1 + 1) )

    opp_stats
  end

  defp calculate(teams) do
    # :matches_played
    # :points
  end
end
