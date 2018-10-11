defmodule OTP.Servers.Frequency.Behaviour do
  def start(module, args), do: spawn(__MODULE__, :init, [module, args])
                               |> Process.register(module)

  def init(module, args), do: module.init(args)
                              |> serve(module)


  def call(message, module) do
    send(module, { :request, self(), message })

    receive do
      {:reply, reply} -> reply
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

  def reply(message, caller), do: send(caller, {:reply, message})

  def stop(module) do
    send(module, { :stop, self() })

    receive do
      {:reply, reply} -> reply
    end
  end
end
