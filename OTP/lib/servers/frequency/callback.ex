defmodule OTP.Servers.Frequency.Callback do
  alias OTP.Servers.Frequency.Behaviour

  @frequencies [10, 11, 12, 13, 14, 15]

  def start, do: Behaviour.start(__MODULE__, [])

  def init(_), do: { @frequencies, %{} }

  def allocate, do: Behaviour.call({:allocate, self()}, __MODULE__)

  def deallocate(frequency),
    do: Behaviour.call({:deallocate, frequency}, __MODULE__)


  def handle({:allocate, pid}, freqs), do: allocate(freqs, pid)

  defp allocate({[], _allocated} = freqs, _pid), do: error(freqs)
  defp allocate({[frequency | tail], allocated}, pid),
    do: { {tail, Map.put(allocated, freq, pid)}, {:ok, freq} }

  def handle({:deallocate, frequency}, freqs),
    do: { deallocate(freqs, frequency), :ok }

  defp deallocate({unused, allocated} = freqs, frequency) do
    if map_size(allocated) == 0 or !Map.get(allocated, frequency),
      do:   error(freqs),
      else: { {[frequency | unused], Map.delete(allocated, frequency)}, :ok }
  end

  defp error(freqs), do: { freqs, {:error, :no_frequency} }


  def stop, do: Behaviour.stop(__MODULE__)

  def terminate, do: :ok
end
