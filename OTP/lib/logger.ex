defmodule OTP.GenStage.Logger do
  use GenStage

  def init(:stdio), do: { :ok, {:stdio, 1} }
  def init({:file, file}) do
    {:ok, pid} = File.open(file, :write)
    { :ok, {pid, 1} }
  end
  def init(args), do: { :error, {:args, args} }

  def terminate(_reason, {term, count}) do
    if is_pid(term), do: File.close(term)
    { :count, count }
  end

  def handle_call(event, _from, {term, count} = state) do
    IO.inspect(event, label)
    IO.inspect(state)
    { :reply, :ok, [event], {term, count+1} }
  end

  def handle_info(event, state), do: noreply(event, state, "Unknown")
  def handle_cast(event, state), do: noreply(event, state, "Event")

  defp noreply(event, {term, count} = state, label) do
    IO.inspect(event, label)
    IO.inspect(state)
    { :noreply, [event], {term, count+1} }
  end

  # @ Retrieving Data
end
