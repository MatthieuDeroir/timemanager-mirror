import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
# config/test.exs
config :timemanagerapp, TimeManagerApp.Repo,
  username: "postgres",
  password: "postgres",
  database: "timemanagerapp_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :timemanagerapp, TimeManagerAppWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "lgGEQ7x2YvnyMI5YL/4+oJ7S2icYsTdMLBR0vs4aCAUJQjzrrZIN4F4m0iL7djDm",
  server: false

# In test we don't send emails
config :timemanagerapp, TimeManagerApp.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
