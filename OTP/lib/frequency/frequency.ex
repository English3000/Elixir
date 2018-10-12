defmodule OTP.Frequency do
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

  def start, do: spawn(__MODULE__, :init, [])
                 |> Process.register(:frequency)

  def init, do: serve({ @frequencies, %{} })

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

  defp allocate({[], _allocated} = freqs, _pid), do: error(freqs)
  defp allocate({[freq | tail], allocated}, pid),
    do: { {tail, Map.put(allocated, freq, pid)}, {:ok, freq} }

  defp deallocate({unused, allocated} = freqs, freq) do
    if map_size(allocated) == 0 or !Map.get(allocated, freq),
      do:   error(freqs),
      else: { {[freq | unused], Map.delete(allocated, freq)}, :ok }
  end

  defp error(freqs), do: { freqs, {:error, :no_frequency} }

  @spec start() :: true
end
