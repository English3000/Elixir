defmodule Challenges.IO do
  @moduledoc """
  Ch. 2 ~ Input, Processing, and Output, "Exercises for Programmers"
  """

  @doc """
  Prompts for your name, and
  Prints a greeting using your name
  """
  # FURTHER STEPS: After Ch. 4, write a version of the program that displays different greetings for different people.
  @type device :: atom | pid
  @spec greeting(String.t, device) :: String.t
  def greeting(name \\ nil, io \\ IO) do
    name = case !!name do
              true -> name
             false -> io.gets("Name: ") |> String.trim
           end

    IO.puts "Hello, #{name}! Nice to meet you"
  end

  @doc """
  Prompts for an input string, and
  Displays output that
    shows the input string, and
    its number of characters
  """
  # FURTHER STEPS: could count # of unique characters
  @spec string_stats(String.t) :: [input: String.t, size: number, chars: String.t, char_count: number]
  def string_stats(input \\ nil, io \\ IO) do
         input = case !!input do
                    true -> input
                   false -> io.gets("String: ") |> String.trim # can add recursive loop for invalid responses
                 end
          size = byte_size(input)
         chars = input |> String.downcase
                       |> String.codepoints
                       |> Enum.uniq
    char_count = length(chars)

    IO.puts "#{input} is #{size} characters long and contains #{char_count} characters."
    [input: input, size: size, chars: chars, char_count: char_count]
  end

  # SKIP: print_quote
  # DO: mad_lib
  # DO: math_display
  # SKIP: Ch. 3
end
