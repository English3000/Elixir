defmodule ProteinTranslation do
  import Enum

  @proteins %{
    "UGU" => "Cysteine",
    "UGC" => "Cysteine",
    "UUA" => "Leucine",
    "UUG" => "Leucine",
    "AUG" => "Methionine",
    "UUU" => "Phenylalanine",
    "UUC" => "Phenylalanine",
    "UCU" => "Serine",
    "UCC" => "Serine",
    "UCA" => "Serine",
    "UCG" => "Serine",
    "UGG" => "Tryptophan",
    "UAU" => "Tyrosine",
    "UAC" => "Tyrosine",
    "UAA" => "STOP",
    "UAG" => "STOP",
    "UGA" => "STOP"
  }
  @doc """
  Given an RNA string, return a list of proteins specified by codons, in order.
  """
  @spec of_rna(String.t()) :: {atom, list(String.t())}
  def of_rna(rna) do
    proteins = rna |> to_charlist |> chunk_every(3) |> reduce_while([],
      fn codon, list ->
        {_, result} = codon |> to_string |> of_codon

        case result do
          "STOP"          -> {:halt, {:ok, list}}
          "invalid codon" -> {:halt, {:error, "invalid RNA"}}
          _ -> {:cont, list ++ [result]}
        end
      end)

    case is_list(proteins) do
      true  -> {:ok, proteins}
      false -> proteins
    end
  end

  @doc """
  Given a codon, return the corresponding protein
  """
  @spec of_codon(String.t()) :: {atom, String.t()}
  def of_codon(codon) do
    result = Map.get(@proteins, codon)

    case !!result do
      true  -> {:ok, result}
      false -> {:error, "invalid codon"}
    end
  end
end
