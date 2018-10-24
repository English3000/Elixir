defmodule OTP.GenStage.Logger do
  use GenStage

  def init(:stdio), do: { :ok, {:stdio, 1} }
  def init({:file, file}) do
    {:ok, device} = File.open(file, :write)
    { :ok, {device, 1} }
  end
  def init(args), do: { :error, {:args, args} }
end
