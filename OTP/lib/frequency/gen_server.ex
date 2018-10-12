defmodule OTP.Frequency.GenServer do
  use GenServer

  @frequencies [10, 11, 12, 13, 14, 15]

  def start,   do: GenServer.start_link(__MODULE__, [], name: :freq_server) # defaults to `timeout: 5000`
  def init(_), do: { :ok, {@frequencies, %{}} }

  def allocate, do: GenServer.call(:freq_server, { :allocate, self() })
  def handle_call({:allocate, pid}, _caller, state) do
    {state_, reply} = allocate(state, pid)
    {:reply, reply, state_}
  end

  def deallocate(freq), do: GenServer.cast(:freq_server, { :deallocate, freq })
  def handle_cast({:deallocate, freq}, state) do
    {:noreply, deallocate(state, freq)}
  end

  def handle_info({:EXIT, _pid, :normal}, state), do: {:noreply, state}
  def handle_info({:EXIT, pid, reason}, state) do
    IO.inspect("PROCESS #{pid} exited: #{reason}")
    {:noreply, state}
  end
  def handle_info(_msg, state),                   do: {:noreply, state}

  def stop,                       do: GenServer.cast(:freq_server, :stop)
  def handle_cast(:stop, state),  do: {:stop, :normal, state} # returning a `:stop` tuple triggers `terminate/2`
  def terminate(_reason, _state), do: :ok
end
