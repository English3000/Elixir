defmodule OTP.Phone.FSM do
  use GenStateMachine, callback_mode: :state_functions

  alias OTP.Phone.Controller
  alias OTP.Frequency.Server.Callback, as: Frequency

  @moduledoc """
  States:

  idle -calling-> calling -hang_up-> idle
                          -connected-> receiving

       -inbound-> connecting -rejected-> idle
                             -connected-> receiving

       -hang_up-> receiving
  """

  # NOTE: Try to refactor down

  @spec start_link(hash) :: {:ok, pid}
  def start_link(hash),
    do: GenStateMachine.start_link(__MODULE__, [hash], name: __MODULE__)
  def init([hash]) do
    Process.flag(:trap_exit, true)
    :hlr.attach(hash)
    { :ok, :idle, hash }
  end

  def idle({:call, caller}, :idle, {:outbound, hash}) do
    case :hlr.lookup_id(hash) do
      {:error, :invalid}          -> Controller.reply(:invalid)
                                     { :next_state, :idle, hash, [{ :reply, caller, {:error, :invalid} }] }

      {:ok, pid} when is_pid(pid) -> Controller.reply(:outbound)
                                     inbound(pid)
                                     { :next_state, :calling, {hash, pid}, [{ :reply, caller, :ok }] }
    end
  end
  def idle({:call, caller}, stage, {:outbound, hash}),
    do: { :next_state, stage, hash, [{ :reply, caller, {:error, :busy} }] }
  def idle(:cast, {:inbound, caller}, hash) do
    Controller.reply(:inbound)
    { :next_state, :receiving, {hash, caller} }
  end
  def idle(:cast, stage, hash) do
    IO.inspect(stage, label: "Idle... ignored")
    { :next_state, :idle, hash }
  end

  def calling(:cast, {:action, :hang_up}, {hash, caller}) do
    hang_up(caller)
    { :next_state, :idle, hash }
  end
  def calling(:cast, :accept, {hash, caller}) do
    case Frequency.allocate() do
      {:error, :no_frequency} -> reject(caller)
                                 Controller.reply(:no_frequency)
                                 { :next_state, :idle, hash }

      {:ok, freq}             -> Controller.reply(:connected)
                                 { :next_state, :connected, {hash, caller, freq} }
    end
  end
  def calling(:cast, :busy, {hash, _caller}) do
    Controller.reply(:busy)
    { :next_state, :idle, hash }
  end
  def calling(:cast, {:inbound, caller}, data) do
    busy(caller)
    { :next_state, :calling, data }
  end
  def calling(:cast, :reject, {hash, caller}) do
    Controller.reply(:rejected)
    { :next_state, :idle, hash }
  end
  def calling(:cast, stage, data) do
    IO.inspect(stage, label: "Calling... ignored")
    { :next_state, :calling, data }
  end

  def connected(:cast, :hang_up, {hash, caller}) do
    Controller.reply(:hang_up)
    { :next_state, :idle, hash }
  end
  def connected(:cast, :hang_up, {hash, caller, freq}) do
    Controller.reply(:hang_up, caller, hash)
    Frequency.deallocate(freq)
    { :next_state, :idle, hash }
  end
  def connected(:cast, stage, data) do
    IO.inspect(stage, label: "Connected... ignored")
    { :next_state, :connected, data }
  end

  def receiving(:cast, {:action, :accept}, data) do
    accept(caller)
    { :next_state, :connected, data }
  end
  def receiving(:cast, {:action, :reject}, {hash, caller}) do
    reject(caller)
    { :next_state, :idle, hash }
  end
  def receiving(:cast, :hang_up, {hash, caller}) do
    Controller.reply(:hang_up)
    { :next_state, :idle, hash }
  end
  def receiving(:cast, {:inbound, caller}, data) do
    busy(caller)
    { :next_state, :receiving, data }
  end
  def receiving(:cast, stage, data) do
    IO.inspect(stage, "Receiving... ignored")
    { :next_state, :receiving, data }
  end

  def terminate(_reason, :idle, _hash), do: :hlr.detach()
  def terminate(_reason, :receiving, {_hash, caller}) do
    reject(caller)
    :hlr.detach()
  end
  def terminate(_reason, _stage, tuple) do
    elem(tuple, 1) |> hang_up()
    :hlr.detach()
  end

  # API
  @type action :: {:outbound, phone_number} | :accept | :reject | :hang_up
  @spec action(pid, action) :: :ok
  @doc "Called by `controller.ex`"
  def action(pid, {:outbound, hash}),
    do: GenStateMachine.call(pid, {:outbound, hash})
  def action(pid, data),
    do: GenStateMachine.cast(pid, {:action, data})

  def  accept(pid), do: GenStateMachine.cast(pid, :accept)
  def    busy(pid), do: GenStateMachine.cast(pid, :busy)
  def hang_up(pid), do: GenStateMachine.cast(pid, :hang_up)
  def inbound(pid), do: GenStateMachine.cast(pid, {:inbound, self()})
  def  reject(pid), do: GenStateMachine.cast(pid, :reject)
end
