defmodule OTP.TimeoutServer do # L 2482
  use GenServer

  def start,   do: GenServer.start_link(__MODULE__, [], name: :timeout_server)
  def init(_), do: {:ok, nil}

  def handle_call({:sleep, time}, _caller, state) do
    :timer.sleep(time)
    {:reply, :ok, state}
  end

  @moduledoc ~S"""
      iex> alias OTP.TimeoutServer, as: TOS

      iex> TOS.start()
      {:ok, _pid}

      iex> GenServer.call(:timeout_server, {:sleep, 1000})
      :ok

      # Never actually do this.
      # `catch GenServer.call(:timeout_server, {:sleep, 5001})`

      iex> flush()

      # Never actually do this.
      # `catch GenServer.call(:timeout_server, {:sleep, 1000})`
  """
end
