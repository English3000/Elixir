# splitStringIntoWords
# (0) Go through the string 1 character at a time.
# (1) In an array, store in an array the start & end index pair of the first substring that exists in the dictionary.
# (2) Proceed from the next index, the start index of the next word. Repeat this process until you’ve reached the end of the string.
# (3) If the last substring isn’t in the dictionary, get the end index of the last stored word. Increment it by one and repeat the dictionary check.
# (4) Repeat this strategy until all characters are accounted for. Otherwise, return nil.
# (5) If you want all valid splits, once (4) has been met, store the result in another array, and then proceed with (3).

# NOTE: Now adjust so function returns all valid splits

defmodule Google do
  @spec split_string_into_words(String.t, String.t) :: String.t
  def split_string_into_words(string, dictionary) do
    if Enum.empty?(dictionary) || String.length(string) == 0 do
      ""
    else
      word_indices = check_if_word(0, 0, [], string, dictionary)
      #iterate through pairs to gen words, then join
      Enum.map_join(word_indices, " ", fn word_indices ->
        String.slice(string, elem(word_indices, 0)..elem(word_indices, 1))
      end)
    end
  end

  defp check_if_word(start_index, end_index, indices_list, string, dictionary) do
    str_length = String.length(string)
    case end_index >= str_length do
       true -> case Enum.empty?(indices_list) || indices_list |> List.last |> elem(1) == str_length - 1 do
                  true -> indices_list
                 false -> step_back(indices_list, string, dictionary)
               end

      false -> case Enum.find_value(dictionary, false, fn word ->
                 word == String.slice(string, start_index..end_index)
               end) do
                  true -> check_if_word(end_index + 1, end_index + 1, indices_list ++ [{start_index, end_index}], string, dictionary) #could build list in reverse for better performance
                 false -> check_if_word(start_index, end_index + 1, indices_list, string, dictionary)
               end
    end
  end

  defp step_back(indices_list, string, dictionary) do
    reverted_list = Enum.slice(indices_list, 0, length(indices_list) - 1)
    tail_pair = reverted_list |> List.last
    check_if_word(elem(tail_pair, 0), elem(tail_pair, 1) + 1, reverted_list, string, dictionary)
  end
end
