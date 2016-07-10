use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :oauthenator_app, OauthenatorApp.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :oauthenator_app, OauthenatorApp.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "oauthenator_app_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :oauthenator, Oauthenator.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "oauthenator_app_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
