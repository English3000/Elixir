# defmodule LibChan.Channel do
#   def start do
#     case :os.getenv("HOME") do
#       false -> exit({:bad_env, "HOME"})
#        home -> start(home ++ "./erlang_config/lib_chan.conf")
#     end
#   end
#
#   def start(config) do
#     IO.inspect(config, label: "`lib_chan` starting")
#     with {:ok, contents} = File.read(config),
#                       [] = validate(contents) do
#       setup(contents)
#     else
#       {:error, reason} -> exit({:bad_config, reason})
#     end
#   end
#
#   defp validate([_] = contents),
#     do: for {:error, reason} <- Enum.map(contents, &validate/1),
#           do: reason
#   defp validate({:port, number}) when is_integer(number), do: :ok
#   defp validate({:service, _, password, _, mfa, _,_,_}),  do: :ok
#   defp validate(term),                                    do: {:error, {:bad_term, term}}
#
#   defp setup(contents),
#     do: spawn(fn -> setup_port(contents) end)
#         |> Process.register(:lib_chan)
#
#   defp setup_port(contents),
#     do: for {:port, number} <- contents,
#           do: setup_port(contents, number)
#
#   defp setup_port(contents, port),
#     do: LibChan.GenServer.start_raw_server(port, fn socket -> start_port(contents, socket) end, 100, 4)
#
#   defp start_port(contents, pid) when is_pid(pid) do
#     receive do
#       {:chan, middleman, {:startService, module, client_args}} when middleman == pid -> # @13368
#     end
#   end
#
#   defp start_port(contents, socket) do
#     pid = self()
#     spawn_link(fn -> start_port(contents, pid) end)
#     |> LibChan.MiddleMan.process(socket)
#   end
# end
