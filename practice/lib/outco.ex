defmodule Outco do
  @spec valid_palindrome(String.t) :: boolean
  def valid_palindrome(string) do
#     start_index = 0
#       end_index = length(string) - 1
#         counter = 0
    matching_letters?(0, String.length(string) - 1, 0, string)
  end

  defp matching_letters?(start_index, end_index, counter, string) do
    cond do
      counter > 1              -> false
      start_index >= end_index -> true

      String.at(string, start_index) == String.at(string, end_index)
                               -> matching_letters?(start_index + 1, end_index - 1, counter, string)

      matching_letters?(start_index + 1, end_index, counter + 1, string) ||
        matching_letters?(start_index, end_index - 1, counter + 1, string)
                               -> true
      # catch all
      true                     -> false
    end
  end
end
