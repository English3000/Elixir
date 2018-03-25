defmodule NucleotideCount do
  # import Enum #then can call `reduce`
  @nucleotides [?A, ?C, ?G, ?T]

  @doc """
  Counts individual nucleotides in a NucleotideCount strand.

  ## Examples

  iex> NucleotideCount.count('AATAA', ?A)
  4

  iex> NucleotideCount.count('AATAA', ?T)
  1
  """
  @spec count([char], char) :: non_neg_integer
  def count(strand, nucleotide) do
    Enum.count(strand, &(&1 == nucleotide))
  end

  @doc """
  Returns a summary of counts by nucleotide.

  ## Examples

  iex> NucleotideCount.histogram('AATAA')
  %{?A => 4, ?T => 1, ?C => 0, ?G => 0}
  """
  @spec histogram([char]) :: map
  def histogram(strand) do
    Enum.reduce(@nucleotides, %{}, fn(nuc, map) ->
      Map.put(map, nuc, NucleotideCount.count(strand, nuc))
    end) # or just count(...)
  end
end

# NOTE: Problem-solving in Elixir, a functional programming language is different from Ruby or JavaScript. Instead of calling methods on an object, like in Ruby, you need to think, "What I am trying to do? Am I trying to Enumerate over a Collection datatype? Or am I trying to modify a basic datatype?"

# Also, because everything is immutable in Elixir AND it does not have enclosures (so if I define a variable inside a function, then call a pre-defined function, as far as I know I cannot pass and then modify that variable in--for example--an Enum call), you need to think in terms of functions, inputs, and outputs. The upside to this is no unexpected side effects on your data! The adaption is logical steps are taken via functions, rather than logic and loops. It's a different paradigm and I'm glad I picked up on my need to adjust.

# I love Elixir's syntax and architecture. I just need to adjust to it.

# The next time I solve a problem:
# 1. What are my inputs?
# 2. What is my required output?
# 3. What do I need to do to convert the inputs into the output?
#      (plot out the pre-defined functions I'll use)
# 4. What is the logical order of those steps?
