defmodule OTP.Phone.Controller do
  alias OTP.Phone.FSM

  # def start(phone_numbers) when is_list(phone_numbers) do
    # NOTE: need Supervisor

  def start(phone_number) do
    FSM.start_link(phone_number)
    call(phone_number)
  end

  def call(phone_number) do
    identifier = :crypto.hash(:sha256, phone_number)
    {:ok, pid} = :hlr.lookup_id(identifier)

    FSM.action(pid, {:outbound, Base.encode16(identifier)})
  end

  def reply(:connected) do
    clear()

    # if status in [:connected, :outbound] do
    #   pid = self()
    #   Process.put(pid, spawn(fn -> FSM.action(:hang_up, pid) end))
    # end
  end
  def reply(:inbound) do
    clear()
    pid = self()
    Process.put(pid, spawn(fn ->
      # FSM.action # :accept | :hang_up | :reject
      # https://github.com/francescoc/scalabilitywitherlangotp/blob/master/ch6/exercise/phone.erl#L52
    end))
  end

  def clear do
    case Process.get(self()) do
      nil                    -> :ok

      pid when self() == pid -> :erlang.exit(pid, :kill)
                                Process.delete(pid)
    end
  end
end
