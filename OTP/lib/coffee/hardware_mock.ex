defmodule OTP.Coffee.HardwareMock do
  @moduledoc """
  Normally, this would be implemented in C,
  with functions triggered by sensors.
  """
  def display(string),
    do: IO.puts "Display: #{string}"

  def return_change(payment),
    do: IO.puts "Machine: Returned #{payment} change"

  def drop_cup,
    do: IO.puts "Machine: Dropped cup"

  def prepare(type),
    do: IO.inspect(type, label: "Machine: Preparing")

  def reboot,
    do: IO.puts "Machine: Rebooted hardware"
end
