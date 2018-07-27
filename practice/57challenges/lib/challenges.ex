defmodule Challenges do
   @bill_prompt "How much is the bill? "
    @tip_prompt "What % are you tipping? "
  @prompt_error "Please enter a positive number."
  # FURTHER STEPS: implement as GUI w/ % slider; could try w/ Absinthe...
  @spec calc_tip(number, number, atom) :: [tip: number, sum: number]
  def calc_tip(bill \\ nil, tip_rate \\ nil, io \\ IO) do
          bill = bill
                 |> prompt(@bill_prompt, io)
                 |> Float.ceil(2)
      tip_rate = prompt(tip_rate, @tip_prompt, io) / 100

           tip = Float.ceil(bill * tip_rate, 2)
    string_tip = Float.to_string(tip) |> decimal_check
    IO.inspect "Tip: $#{string_tip}"

           sum = bill + tip
    string_sum = Float.to_string(sum) |> decimal_check
    IO.inspect "Total: $#{string_sum}"

    [tip: tip, sum: sum] #or {tip, sum}
  end

  defp prompt(amount, prompt, io \\ IO)
  defp prompt(amount, _prompt, _io) when is_number(amount) and amount >= 0, do: amount / 1
  defp prompt(_amount, prompt, io) do
    try do
      amount = io.gets(prompt)
               |> String.trim
               |> String.trim_trailing("%")

      amount = case String.contains?(amount, ".") do
                  true -> String.to_float(amount)
                 false -> String.to_integer(amount) / 1
               end

      unless amount >= 0 do
        IO.puts @prompt_error
        prompt("", prompt)
      end

      amount
    rescue
      _ in ArgumentError -> IO.puts @prompt_error
                            prompt("", prompt)
    end
  end

  defp decimal_check(string_tip) do
    case String.at(string_tip, byte_size(string_tip) - 3) == "." do
      false -> decimal_check(string_tip <> "0")
       true -> string_tip
    end
  end
end
