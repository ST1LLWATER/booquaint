# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :booquaint,
  ecto_repos: [Booquaint.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :booquaint, BooquaintWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [json: BooquaintWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Booquaint.PubSub,
  live_view: [signing_salt: "pBZLKYbw"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :booquaint, Booquaint.Auth.Guardian,
  issuer: "booquaint",
  secret_key: "0AFvjYbH+Ej2YauC1d0Vlet7eLs2jurlvn5lcHbndigNNW1wxM56ytQqBqi4N+Cf"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
