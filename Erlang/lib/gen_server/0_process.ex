defmodule GenServer.Process do
  def start(name, server),
    do: Process.register(spawn(fn -> process(name, server, server.init()) end), name)

  @doc "hot module loading"
  def load(name, server),
    do: call(name, {:load, server})

  def call(name, request) do
    send(name, {self(), request})
    receive do
             {atom, :crash} when atom == name -> exit :crashed
      {atom, :ok, response} when atom == name -> response
    end
  end

  def process(name, server, state) do
    receive do
      {caller, {:load, module}} -> send(caller, {name, :ok, :received})
                                   process(name, module, state)

      {caller, request} ->
        try do
          {response, new_state} = server.handle(request, state)
          send(caller, {name, :ok, response})
          process(name, server, new_state)
        catch
          error -> log_error(name, request, error)
                   send(caller, {name, :crash})
                   process(name, server, state)
        end
    end
  end

  def log_error(name, request, error) do
    IO.inspect """
    Server: #{name}
    Request: #{request}
    Error: #{error}
    """
  end
end
