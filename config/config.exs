# This file is responsible for configuring your umbrella
# and **all applications** and their dependencies with the
# help of the Config module.
#
# Note that all applications in your umbrella share the
# same configuration and dependencies, which is why they
# all use the same configuration file. If you want different
# configurations or dependencies per app, it is best to
# move said applications out of the umbrella.
import Config

config :apis,
  generators: [context_app: false]

# Configures the endpoint
config :apis, Apis.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "pXJs7B8+hFz3H4mcy/q9yIf2/So41jJRHwCkYEBUp2X6l7/MHcIzEUBDBZgKn2tE",
  render_errors: [view: Apis.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Apis.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "/zYr1uT/"]

config :apis,
  ecto_repos: [Apis.Repo],
  generators: [context_app: false]

# Configures the endpoint
config :apis, Apis.Endpoint,
  url: [host: "localhost"],
  server: true,
  secret_key_base: "GivARm//IhknrdcYXaoUz5PsV74lCEEd0clyY9Y5nHYmdVt7E1SbkgP0vHRbI4sL",
  render_errors: [view: Apis.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Apis.PubSub, adapter: Phoenix.PubSub.PG2],
  live_view: [signing_salt: "qExyEay8"]

# Sample configuration:
#
#     config :logger, :console,
#       level: :info,
#       format: "$date $time [$level] $metadata$message\n",
#       metadata: [:user_id]
#

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
