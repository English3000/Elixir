defmodule OTP.Servers.Frequency do
  # replace w/ MapSet -- more performant; write MapSet.get
  @frequencies [10, 11, 12, 13, 14, 15]

  defp call(msg) do
    send(:frequency, {:request, self(), msg})

    receive do
      {:reply, reply} -> reply
    end
  end

  def allocate,         do: call(:allocate)
  def deallocate(freq), do: call({:deallocate, freq})
  def stop,             do: call(:stop)

  @spec allocate() ::
    {:ok, frequency :: pid} | {:error, :no_frequency}
  @spec deallocate(frequency :: pid) :: :ok
  @spec stop() :: :ok

  def start, do: Process.register(spawn(__MODULE__, :init, []), :frequency)

  def init, do: serve({@frequencies, []})

  defp serve(freqs) do
    receive do
      {:request, pid, :allocate}           -> {freqs_, reply} = allocate(freqs, pid)
                                              reply(pid, reply)
                                              serve(freqs_)

      {:request, pid, {:deallocate, freq}} -> {freqs_, reply} = deallocate(freqs, freq)
                                              reply(pid, reply)
                                              serve(freqs_)

      {:request, pid, :stop}               -> reply(pid, :ok)
    end
  end

  defp reply(pid, msg), do: send(pid, {:reply, msg})

  defp allocate({[], _allocated} = freqs, _pid),
    do: { freqs, {:error, :no_frequency} }
  defp allocate({[freq | tail], allocated}, pid),
    do: { {tail, [{freq, pid} | allocated]}, {:ok, freq} }

  defp deallocate({free, allocated} = freqs, freq) do
    case Enum.find(allocated, fn {fr, _pid} -> fr == freq end) do
      nil -> { freqs, {:error, :no_frequency} }
      _pid -> { {[freq | free], List.keydelete(allocated, freq, 0)}, :ok }
    end
  end

  @spec start() :: true
end
