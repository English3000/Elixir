defmodule OTP.Coffee.GenStateMachine do
  use GenStateMachine, callback_mode: :state_functions
  # https://hexdocs.pm/gen_state_machine/GenStateMachine.html
  # https://github.com/brianbroderick/gen_state_machine_examples/tree/master/lib
  alias OTP.Coffee.HardwareMock

  @timeout 10_000

  @select "Make your selection"
  @pay "Please pay "

  def start_link,
    do: GenStateMachine.start_link(__MODULE__, [], name: __MODULE__)

  def init(_) do
    HardwareMock.reboot()
    HardwareMock.display @select
    # Process.whereis(__MODULE__) |>
    Process.flag(:trap_exit, true)
    { :ok, :selection, nil } # {:ok, stage, state} # , timeout
  end

  def tea,       do: GenStateMachine.cast(__MODULE__, {:selection, :tea,       100})
  def espresso,  do: GenStateMachine.cast(__MODULE__, {:selection, :espresso,  100})
  def americano, do: GenStateMachine.cast(__MODULE__, {:selection, :americano, 150})
  def cappucino, do: GenStateMachine.cast(__MODULE__, {:selection, :cappucino, 150})

  def pay(amount), do: GenStateMachine.cast(__MODULE__, {:pay, amount})
  def cancel,      do: GenStateMachine.cast(__MODULE__, :cancel)
  def cup_removed, do: GenStateMachine.cast(__MODULE__, :cup_removed)

  def selection(:cast, {:selection, type, price}, _state) do
    HardwareMock.display(@pay <> to_string(price))
    { :next_state, :payment, {type, price, 0}, @timeout }
  end
  def selection(:cast, {:pay, amount}, state) do
    HardwareMock.return_change(amount)
    { :next_state, :selection, state }
  end
  def selection(:cast, stage, state),
    do: { :next_state, stage, state }

  def payment(:cast, {:pay, amount}, {type, price, paid})
    when paid + amount < price do
    inserted = paid + amount
    HardwareMock.display(@pay <> to_string(price - inserted))
    { :next_state, :payment, {type, price, inserted}, @timeout }
  end
  def payment(:cast, {:pay, amount}, {type, price, paid}) do
    HardwareMock.display "Preparing drink"
    HardwareMock.return_change(paid + amount - price)
    HardwareMock.drop_cup
    HardwareMock.prepare(type)
    HardwareMock.display "Remove drink"
    { :next_state, :remove, nil }
  end
  def payment(:cast, :cancel, {_type, _price, paid}) do
    HardwareMock.return_change(paid)
    HardwareMock.display @select
    { :next_state, :selection, nil }
  end
  def payment(:timeout, _stage, {_type, _price, paid}) do
    IO.puts "timeout"
    HardwareMock.return_change(paid)
    HardwareMock.display @select
    { :next_state, :selection, nil }
  end
  def payment(:cast, stage, state),
    do: { :next_state, stage, state }

  def remove(:cast, :cup_removed, state) do
    HardwareMock.display @select
    { :next_state, :selection, state }
  end
  def remove(:cast, {:pay, amount}, state) do
    HardwareMock.return_change(amount)
    { :next_state, :remove, state }
  end
  def remove(:cast, stage, state),
    do: { :next_state, stage, state }

  # NOT WORKING
  # def handle_event(:cast, _, stage, state),
  #   do: { :next_state, stage, state }

  def terminate(_reason, :payment, {_type, _price, paid}),
    do: HardwareMock.return_change(paid)
  def terminate(_reason, _stage, _state), do: :ok
end
