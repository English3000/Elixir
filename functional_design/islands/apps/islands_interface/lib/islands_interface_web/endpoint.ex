defmodule IslandsInterfaceWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :islands_interface

  socket "/socket", IslandsInterfaceWeb.UserSocket,
    websocket: true,
    longpoll: false

  # Serves static files from "./priv/static" at "/"
  # NOTE: Set `gzip: true` when running `phx.digest` (deploy prep)
  plug Plug.Static,
    at:   "/",
    from: :islands_interface,
    gzip: false,
    only: ~w(css fonts images js favicon.ico robots.txt)

  # To enable code reloading, set `code_reloader: true` in env config.
  # if code_reloading? do
  #   socket "/phoenix/live_reload/socket", Phoenix.LiveReloader.Socket
  #   plug Phoenix.LiveReloader
  #   plug Phoenix.CodeReloader
  # end

  plug Plug.RequestId
  plug Plug.Logger

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session,
    store: :cookie,
    key: "_islands_interface_key",
    signing_salt: "Lpo8YQlH"

  plug IslandsInterfaceWeb.Router
end
