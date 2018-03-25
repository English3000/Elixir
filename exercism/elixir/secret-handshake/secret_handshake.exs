defmodule SecretHandshake do
  @handshakes %{
    '1' => "wink",
    '10' => "double blink",
    '100' => "close your eyes",
    '1000' => "jump"
  }
  @doc """
  Determine the actions of a secret handshake based on the binary
  representation of the given `code`.

  If the following bits are set, include the corresponding action in your list
  of commands, in order from lowest to highest.

  1 = wink
  10 = double blink
  100 = close your eyes
  1000 = jump

  10000 = Reverse the order of the operations in the secret handshake
  """
  @spec commands(code :: integer) :: list(String.t())
  def commands(code) do
    # givens:
    # * input: integer
    # * map: decoding

    # output: list of strings

    # modified recursive solution from alxtz: http://exercism.io/submissions/84ff000985b14d67a83cd627a9a0150c
    cond do
      code >= 16 -> Enum.reverse(commands(code - 16))
      code >= 8  -> commands(code - 8) ++ [
        Map.get(@handshakes, Integer.to_charlist(8, 2))
      ]
      code >= 4  -> commands(code - 4) ++ [
        Map.get(@handshakes, Integer.to_charlist(4, 2))
      ]
      code >= 2  -> commands(code - 2) ++ [
        Map.get(@handshakes, Integer.to_charlist(2, 2))
      ]
      code >= 1  -> commands(code - 1) ++ [
        Map.get(@handshakes, Integer.to_charlist(1, 2))
      ]
      code >= 0  -> []
    end
  end
end
