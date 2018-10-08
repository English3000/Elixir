defmodule WebSocket.Shell.Server do
  def start(browser) do
    send(browser, %{cmd: :append_div, id: :scroll, text: "Starting Erlang shell:<br>"})
    bindings = :erl_eval.new_bindings ##
    process(browser, bindings, 1)
  end

  def process(browser, bindings, n) do
    receive do
      {pid, %{entry: "input", text: string}} when pid == browser ->
        # L 7831
    end
  end
end
