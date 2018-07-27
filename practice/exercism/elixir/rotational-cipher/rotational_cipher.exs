defmodule RotationalCipher do
  @doc """
  Given a plaintext and amount to shift by, return a rotated string.

  Example:
  iex> RotationalCipher.rotate("Attack at dawn", 13)
  "Nggnpx ng qnja"
  """
  @spec rotate(text :: String.t(), shift :: integer) :: String.t()
  def rotate(text, shift) do
    if shift == 0 do
      text
    else
      cond do
        shift < 0 -> shift = 26 + rem(shift, 26)
        shift > 26 -> shift = rem(shift, 26)
        true -> shift
      end

      Enum.map(String.to_charlist(text), fn ch ->
        new_ch = ch + shift

        cond do
          ch < 65 or ch > 122 or (ch > 90 and ch < 97) ->
            new_ch = ch

          (ch <= 90 and new_ch > 90) or (ch >= 97 and new_ch > 122) ->
            new_ch = new_ch - 26

          true ->
            new_ch
        end

        List.to_string([new_ch])
      end)
      |> Enum.join()
    end
  end
end
