defmodule OTP.Supervisor do # @ L 4695
  @moduledoc """
  iex> OTP.Supervisor.start([{OTP.Coffee.FSM, :start_link, []}], name: :sup)
  Machine: Rebooted hardware
  Display: Make your selection
  {:ok, #PID<0.173.0>}
  """
  def start(children, options) do
    pid = spawn(__MODULE__, :init, [children])

    if name = Keyword.get(options, :name),
      do: Process.register(pid, name)

    { :ok, pid }
  end

  # def init(children) do
  #   Process.flag(:trap_exit, true)
  #
  #   children
  #   |> start_children()
  #   |> serve
  # end

  def start_link, do: Supervisor.start_link(__MODULE__, __MODULE__, [])

                   # Supervisor spec
  def init(_), do: { :ok, {{:rest_for_one, 2, 3_600}, [child(:freq_overload), child(:frequency)]} }

  def child(module), do: {module, {module, :start_link, []}, :permanent, 2_000, :worker, [__MODULE__]}

  @doc "Generates local process registry for child processes."
  def start_children(children) do
    for {module, function, args} <- children do
                        # { :ok, pid }
      { apply(module, function, args) |> elem(1), {module, function, args} }
    end
  end

  defp serve(children) do
    receive do
      {:EXIT, pid, :normal} -> List.keydelete(children, pid, 0) |> serve()
      {:EXIT, pid, _reason} -> restart_child(children, pid) |> serve()
                      :stop -> terminate(children)
    end
  end

  def restart_child(children, pid) do
    { pid, {module, function, args} } = List.keyfind(children, pid, 0)
    { :ok, new_pid } = apply(module, function, args)
    List.keyreplace(children, pid, 0, { new_pid, {module, function, args} })
  end

  def stop(sup, _reason, _timeout), do: send(sup, :stop)

  def terminate(children),
    do: Enum.each(children, fn {pid, _} -> :erlang.exit(pid, :kill) end)
end
