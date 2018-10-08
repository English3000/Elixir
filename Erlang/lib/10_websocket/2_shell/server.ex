defmodule WebSocket.Shell.Server do # L 7859: Creating a Chat Widget (resume once working...)
  def start(browser) do
    send(browser, %{cmd: :append_div, id: :scroll, text: "Starting Erlang shell:<br>"})
    bindings = :erl_eval.new_bindings
    process(browser, bindings, 1)
  end

  defp process(browser, bindings, n) do
    receive do
      {pid, %{entry: "input", text: string}} when pid == browser ->
        {result, new_bindings} = String.graphemes(string) |> parse(bindings)
        send(browser, %{cmd: :append_div, id: :scroll, text: "#{n} > <font color='red'>#{string}</font><br>#{result}"})
        process(browser, new_bindings, n+1)
    end
  end

  defp parse(letters, bindings) do
    with {:ok, tokens, _} <- :erl_scan.string(letters),
         {:ok, expressions} <- :erl_parse.parse_exprs(tokens)
    do
      {:value, value, expr_bindings} = :erl_eval.exprs(expressions, bindings)
    else
      failure -> IO.inspect(letters, label: "Can't tokenize")
                 IO.inspect(failure, label: "REASON")
    end
  end
end
