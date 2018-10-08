defmodule MyCowboy do # @ Location 11934
  def start(port) do
    :ok = :application.start(:crypto)
    :ok = :application.start(:ranch)
    :ok = :application.start(:cowboy)
                                      # host, path, handler, options
    dispatch = :cowboy_router.compile([{'_', [{'_', :my_cowboy, []}]}])
    :cowboy.start_http(:server, 10, [port: port], [env: [dispatch: dispatch]]) # starts 10 processes
  end

  def init({:tcp, :http}, request, _options),
    do: {:ok, request, nil}

  def handle(request, state) do
    {path, request} = :cowboy_req.path(request)
    response = read(path) # grabs file from server
    {:ok, request} = :cowboy_req.reply(200, [], response, request) # sends it to client

    {:ok, request, state}
  end
  defp read(path) do
    file = "." <> path

    case File.read(file) do
      {:ok, html} -> html
                _ -> "<pre>cannot read: #{file}</pre>"
    end
  end

  def terminate(_reason, _request, _state), do: :ok
end
