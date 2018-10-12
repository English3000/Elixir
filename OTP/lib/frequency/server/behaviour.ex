defmodule OTP.Frequency.Server.Behaviour do
  def start(module, args), do: spawn(__MODULE__, :init, [module, args])
                               |> Process.register(module)

  def init(module, args), do: module.init(args)
                              |> serve(module)


  def call(message, module, timeout \\ 5000) do
    ref = Process.monitor(module)

    try do
      send(module, { :request, { ref, self() }, message })
    rescue
      err -> if err != :timeout, do: nil, else: exit(err)
    end

    receive do
      { :reply, reference, reply } when reference == ref ->
        Process.demonitor(ref, [:flush])
        reply

      { :DOWN, reference, :process, _module, _reason } when reference == ref ->
        { :error, :no_process }
    after
      timeout -> exit(:timeout)
    end
  end

  def serve(state, module) do
    receive do
      { :request, caller, msg } -> {state_, msg_} = module.handle(msg, state)
                                   reply(msg_, caller)
                                   serve(state_, module)

      { :stop,    caller }      -> module.terminate(state)
                                   |> reply(caller)
    end
  end

  def reply(message, {ref, caller}), do: send(caller, {:reply, ref, message})

  def stop(module) do
    send(module, { :stop, self() })

    receive do
      {:reply, reply} -> reply
    end
  end
end
