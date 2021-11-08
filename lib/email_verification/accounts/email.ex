defmodule EmailVerification.Accounts.Email do
  import Swoosh.Email

  alias EmailVerification.Mailer

  def deliver(user) do
    email =
      new()
      |> to("087079e608-1a1dba@inbox.mailtrap.io")
      |> from("087079e608-1a1dba@inbox.mailtrap.io")
      |> subject("App Login")
      |> html_body("
            <h1>Verification Required</h1>
            <p>Kindly click the link given below to verify your email.</p>
            <a href=http://localhost:4000/api/v1/auth/verify_email/#{user.token}>Email Verification Link!</a>
      ")
      |> text_body("Email sending for verification of your respective email.")

    IO.inspect(email)

    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end

end
