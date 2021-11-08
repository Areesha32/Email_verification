defmodule EmailVerification.Repo do
  use Ecto.Repo,
    otp_app: :email_verification,
    adapter: Ecto.Adapters.Postgres
end
