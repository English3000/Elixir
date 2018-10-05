# ** REVIEW: http://erlang.org/doc/design_principles/des_princ.html **
# source code for `spawn` ~ https://github.com/mfoemmel/erlang-otp/blob/master/erts/preloaded/src/erlang.erl#L136

# in Elixir, using `Task.async/1,3` && `Task.await/2` is the equiv of `spawn` + `send` && selective `receive`
#
# `Task.await/2` is literally an amped up `receive` block: https://github.com/elixir-lang/elixir/blob/v1.7.3/lib/elixir/lib/task.ex#L504
defmodule Parallel do # @ L 12212
  @doc """
  `Parallel.map/2` works like `Enum.map/2`, except
  it creates one parallel process to evaluate each argument in `list`.

  Note that the processes can complete in any order.

  The selective `receive` in `gather/2` ensures that
  the order of the arguments in the return value corresponds to
  the ordering in the original list.

  Don’t use `Parallel.map/2` if the amount of work done in the function is small...
  The overhead of setting up a process and waiting for a reply
  is greater than the benefit of using parallel processes
  """
  def map(list, function) do
    pid = self()
    ref = make_ref()

    Enum.map(list, &spawn(fn -> send(pid, {self(), ref, function.(&1)}) end))
    |> process(ref)
  end

  def process([pid | tail], ref) do
    receive do
      {parent_pid, parent_ref, value} when parent_pid == pid and parent_ref == ref ->
        [value | process(tail, ref)]
    end
  end

  def gather([], _), do: []
end
