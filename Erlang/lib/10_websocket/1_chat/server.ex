defmodule WebSocket.Chat.Server do
  def start(browser),
    do: process(browser)

  defp process(browser) do
    receive do
      {pid, %{entry: "input", text: string}} when pid == browser ->
        send(browser, %{cmd: :append_div, id: :scroll, text: "#{WebSocket.Clock.Server.current_time} > #{string}<br>"})
    end

    process(browser)
  end
end
