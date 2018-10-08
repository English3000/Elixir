defmodule WebSocket.Clock.Server do
  def start(browser) do
    send(browser, %{cmd: :fill_div, id: :clock, text: current_time()})
    process(browser)
  end

  def current_time do
    time = Time.utc_now
    "#{time.hour}:#{time.minute}:#{time.second}"
  end

  defp process(browser) do
    receive do
      {pid, %{"clicked"=> "stop"}} when pid == browser -> idle(browser)
    after
      1000 -> start(browser)
    end
  end

  defp idle(browser) do
    receive do
      {pid, %{"clicked"=> "start"}} -> process(browser)
    end
  end
end
