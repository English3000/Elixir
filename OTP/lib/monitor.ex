defmodule OTP.Monitor do
  use GenServer

  @timeout 5_000

  def init(_),
    do: {:ok, nil, @timeout}

  def handle_call(:start, _caller, state),
    do: {:reply, :started, state, @timeout}

  def handle_call(:pause, _caller, state),
    do: {:reply, :paused, state}

  def handle_info(:timeout, state) do
    IO.inspect Time.utc_now().second
    {:noreply, state, @timeout}
  end

  @moduledoc ~S"""
      iex> GenServer.start(OTP.Monitor, [], name: :mon_server)

      iex> GenServer.call(:mon_server, :pause)

      iex> GenServer.call(:mon_server, :start)
  """
end
