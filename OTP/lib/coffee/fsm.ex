defmodule OTP.Coffee.FSM do
  @moduledoc """
  `receive` blocks = different states

  > untested
  """
  alias OTP.Coffee.HardwareMock

  @select "Make your selection"
  @pay "Please pay "

  def start_link, do: {:ok, spawn_link(__MODULE__, :init, [])}
  def init do
    Process.register(self(), __MODULE__)
    HardwareMock.reboot()
    HardwareMock.display(@select, [])
    selection()
  end

  def selection do
    receive do
      {:selection, type, price} -> HardwareMock.display(@pay <> to_string(price))
                                   payment(type, price, 0)

      {:pay, coin} -> HardwareMock.return_change(coin)
                      selection()

      _ -> selection() # on `cancel/0`
    end
  end

  defp tea,       do: send(__MODULE__, {:selection, :tea,       100})
  defp espresso,  do: send(__MODULE__, {:selection, :espresso,  150})
  defp americano, do: send(__MODULE__, {:selection, :americano, 100})
  defp cappucino, do: send(__MODULE__, {:selection, :cappucino, 150})

  defp cup_removed, do: send(__MODULE__, :cup_removed)
  defp pay(coin),   do: send(__MODULE__, {:pay, coin})
  defp cancel,      do: send(__MODULE__, :cancel)

  def payment(type, price, paid) do
    receive do
      {:pay, coin} -> if coin + paid >= price do
                        HardwareMock.display("Preparing drink", [])
                        HardwareMock.return_change(coin + paid - price)
                        HardwareMock.drop_cup
                        HardwareMock.prepare(type)
                        HardwareMock.display("Remove drink", [])
                        remove()
                      else
                        inserted = coin + paid
                        HardwareMock.display(@pay <> to_string(price - inserted))
                        payment(type, price, inserted)
                      end

      :cancel -> HardwareMock.display(@select)
                 HardwareMock.return_change(paid)
                 selection()

      _ -> payment(type, price, paid) # on `selection/0`
    end
  end

  def remove do
    receive do
      :cup_removed -> HardwareMock.display(@select, [])
                      selection()

      {:pay, coin} -> HardwareMock.return_change(coin)
                      remove()

                 _ -> remove() # on `cancel/0` or `selection/0`
    end
  end
end
