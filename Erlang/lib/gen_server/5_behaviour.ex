defmodule GenServer.Behaviour do
  def start_link,
    do: GenServer.start_link(__MODULE__, [])

  @callback init([]) :: {:ok, state :: list}

  @callback handle_call(_request :: tuple | atom, _caller :: pid, state :: list) :: {:reply, reply :: tuple, state :: list}

  @callback handle_cast(_message :: any, state :: list) :: {:noreply, state :: list}

  @callback handle_info(_info :: any, state :: list) :: {:noreply, state :: list}

  @callback terminate(_reason :: any, _state :: list) :: :ok

  @callback code_change(_old_version :: number, state :: list, _extra :: any) :: {:ok, state :: list}
end
