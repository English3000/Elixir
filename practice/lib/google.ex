# # splitStringIntoWords
# # (0) Go through the string 1 character at a time.
# # (1) In an array, store in an array the start & end index pair of the first substring that exists in the dictionary.
# # (2) Proceed from the next index, the start index of the next word. Repeat this process until you’ve reached the end of the string.
# # (3) If the last substring isn’t in the dictionary, get the end index of the last stored word. Increment it by one and repeat the dictionary check.
# # (4) Repeat this strategy until all characters are accounted for. Otherwise, return nil.
# # (5) If you want all valid splits, once (4) has been met, store the result in another array, and then proceed with (3).
#
# @spec split_string_into_words(String.t, String.t) :: String.t
# defmodule Google do
#   def split_string_into_words(string, dictionary) do
#     word_indices = check_if_word(0, 0, [], string, dictionary)
#     #iterate through pairs to gen words, then join
#     Enum.map_join(word_indices, " ", fn word_indices ->
#       String.slice(string, elem(word_indices, 0)..elem(word_indices, 1))
#     end)
#   end
#
#   defp check_if_word(start_index, end_index, indices_list, string, dictionary) do
#     cond do
#       #base case: for an index pointing outside the string, if the full string has been accounted for, return the list of index pairs; otherwise,
#       end_index >= String.length(string) --> step_back(indices_list, string, dictionary)
#       start_index >= String.length(string) -->
#         #working solution
#         if indices_list |> List.last |> List.last == start_index do
#           indices_list
#         else
#           #for an invalid set of splits, revert back 1 step & try seeking a longer word
#           step_back(indices_list, string, dictionary)
#         end
#       true -->
#         if Enum.find_value(dictionary, fn word -> word == String.slice(string, start_index..end_index) do
#           check_if_word(end_index + 1, end_index + 1, indices_list ++ [{start_index, end_index}], string, dictionary) #could build list in reverse for better performance
#         else
#           check_if_word(start_index, end_index + 1, indices_list, string, dictionary)
#         end
#     end
#   end
#
#   defp step_back(indices_list, string, dictionary) do
#     reverted_list = Enum.slice(indices_list, 0, length(indices_list - 1))
#     check_if_word(reverted_list |> List.last |> List.first, reverted_list |> List.last |> List.last + 1, reverted_list, string, dictionary)
#   end
# end
