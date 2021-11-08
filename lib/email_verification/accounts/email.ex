defmodule EmailVerification.Accounts.Email do
  # import Bamboo.Email
  import Swoosh.Email

  alias EmailVerification.Mailer
  # def welcome_email do
  #   new_email(
  #     to: "087079e608-1a1dba@inbox.mailtrap.io",
  #     from: "087079e608-1a1dba@inbox.mailtrap.io",
  #     subject: "Welcome to the app.",
  #     html_body: "<strong>Thanks for joining!</strong>",
  #     text_body: "Thanks for joining!"
  #   )

  # end

  defp deliver() do
    email =
      new()
      |> to("arisha.iftikhar@gmail.com")
      |> from("087079e608-1a1dba@inbox.mailtrap.io")
      |> subject("Welcome to the app.")
      |> text_body("Thanks for joining!")

    IO.inspect(email)

    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end

  def deliver_confirmation_instructions() do
    deliver()
  end
end
