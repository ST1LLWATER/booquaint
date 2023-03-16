defmodule BooquaintWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :booquaint

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  @session_options [
    store: :cookie,
    key: "_booquaint_key",
    signing_salt: "6IHJR2Qu",
    same_site: "Lax"
  ]

  plug Plug.Session,
    store: :cookie,
    key: "Auth",
    encryption_salt: "0AFvjYbH+Ej2YauC1d0Vlet7eLs2jurlvn5lcHbndigNNW1wxM56ytQqBqi4N+Cf",
    signing_salt: "0AFvjYbH+Ej2YauC1d0Vlet7eLs2jurlvn5lcHbndigNNW1wxM56ytQqBqi4N+Cf",
    key_length: 64,
    log: :debug

  # socket "/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]]

  # Serve at "/" the static files from "priv/static" directory.
  #
  # You should set gzip to true if you are running phx.digest
  # when deploying your static files in production.
  plug Plug.Static,
    at: "/",
    from: :booquaint,
    gzip: false,
    only: BooquaintWeb.static_paths()

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :booquaint
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug BooquaintWeb.Router
end
