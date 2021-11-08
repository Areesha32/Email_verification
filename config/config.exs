# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :email_verification, EmailVerification.Guardian,
  allowed_algos: ["HS512"], # optional
  verify_module: Guardian.JWT,  # optional
  issuer: "email_verification",
  ttl: { 30, :days },
  allowed_drift: 2000,
  verify_issuer: true, # optional
  secret_key: "9teNnjuLabq0WbNEFq/pY78S/CI3Fj3fz001xhMwT/GCKOnGV5DsPytjoQWVELXh",
  serializer: EmailVerification.GuardianSerializer


config :email_verification,
  ecto_repos: [EmailVerification.Repo]

# Configures the endpoint
config :email_verification, EmailVerificationWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: EmailVerificationWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: EmailVerification.PubSub,
  live_view: [signing_salt: "oNWCkrjW"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :email_verification, EmailVerification.Mailer, adapter: Swoosh.Adapters.SMTP

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.12.18",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2016 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
