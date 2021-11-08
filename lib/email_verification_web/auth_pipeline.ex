defmodule EmailVerification.Guardian.AuthPipeline do
  use Guardian.Plug.Pipeline, otp_app: :email_verification,
  module: EmailVerification.Guardian,
  error_handler: EmailVerification.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
