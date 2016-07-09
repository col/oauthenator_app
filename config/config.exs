# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :oauthenator_app,
  ecto_repos: [OauthenatorApp.Repo, Oauthenator.Repo]

# Configures the endpoint
config :oauthenator_app, OauthenatorApp.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "KBlc1C52b8rZW1hvzomApMV+Gri8yvQ0t3r4p8q4oUcpPofYa0l/Paa5L84fpZFS",
  render_errors: [view: OauthenatorApp.ErrorView, accepts: ~w(html json)],
  pubsub: [name: OauthenatorApp.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
