defmodule GenServer.Bank do # @ L 10275
  @behaviour GenServer.Behaviour

  def start, do: GenServer.start_link(__MODULE__, [])
  def init([]),
    do: {:ok, :ets.new(__MODULE__, [])}

  def stop, do: GenServer.call(__MODULE__, :stop)
  def handle_call(:stop, _caller, table),
    do: {:stop, :normal, :stopped, table}

  def new_account(owner), do: GenServer.call(__MODULE__, {:new, owner})
  def handle_call({:new, owner}, _caller, table) do
    reply = case :ets.lookup(table, owner) do
               [] -> :ets.insert(table, {owner, 0})
                     {:welcome, owner}
              [_] -> {owner, :already_registered}
            end

    {:reply, reply, table}
  end

  def deposit(owner, amount), do: GenServer.call(__MODULE__, {:add, owner, amount})
  def handle_call({:add, owner, amount}, _caller, table) do
    reply = case :ets.lookup(table, owner) do
                              [] -> :no_account

              [{owner, balance}] -> total = balance + amount
                                    :ets.insert(table, {owner, total})
                                    {:deposited, owner, :balance, total}
            end

    {:reply, reply, table}
  end

  def withdraw(owner, amount), do: GenServer.call(__MODULE__, {:remove, owner, amount})
  def handle_call({:remove, owner, amount}, _caller, table) do
    reply = case :ets.lookup(table, owner) do
              [] -> :no_account

              [{owner, balance}] when amount <= balance ->
                total = balance - amount
                :ets.insert(table, {owner, total})
                {:withdrawn, owner, :balance, total}

              [{owner, balance}] -> {:overdraw, owner, :balance, balance}
            end

    {:reply, reply, table}
  end

  def handle_cast(_message, state),
    do: {:noreply, state}

  def handle_info(_info, state),
    do: {:noreply, state}

  def terminate(_reason, _state),
    do: :ok

  def code_change(_old_version, state, _extra),
    do: {:ok, state}
end
