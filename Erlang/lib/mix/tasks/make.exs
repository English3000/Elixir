# NIFs in Elixir: https://spin.atomicobject.com/2015/03/16/elixir-native-interoperability-ports-vs-nifs/
defmodule Mix.Tasks.Compile.Make do
  use Mix.Project

  def run(_) do
    {result, _error} = System.cmd("make", [], stderr_to_stdout: true)
    Mix.Shell.info(result) ; :ok
  end
end

defmodule Mix.Tasks.Clean.Make do
  def run(_) do
    {result, _error} = System.cmd("make", ['clean'], stderr_to_stdout: true)
    Mix.Shell.info(result) ; :ok
  end
end
