defmodule EmailVerificationWeb.UserController do
  use EmailVerificationWeb, :controller

  alias EmailVerification.Accounts
  alias EmailVerification.Accounts.User

  action_fallback EmailVerificationWeb.FallbackController

  alias EmailVerification.Guardian
  alias EmailVerification.Accounts.Email

  def index(conn, _params) do
    users = Accounts.list_users()
    render(conn, "index.json", users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Accounts.create_user(user_params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      Email.deliver(user)
      conn |> render("jwt.json", jwt: token)
    end
  end

  def sign_in(conn, %{"email" => email, "password" => password}) do
    {:ok, user} = Accounts.get_by_email(email)
    IO.inspect(user.email_verified)
    if user.email_verified == true do
      case Accounts.token_sign_in(email, password) do
        {:ok, token, _claims} ->
          conn |> render("jwt.json", jwt: token)

        _ ->
          {:error, :unauthorized}
      end

    else
      {:error, :not_verified}
    end
  end

  def verify_email(conn, %{"token" => token}) do
    user = Accounts.get_by_token(token)

    if user do
      if user.email_verified != true do
        with {:ok, %User{} = user} <- User.verify_email(user) do
          conn
          |> put_status(200)
          |> render("verify_email.json", user: user)
        end
      else
        conn |> json(%{error: "This email has already verified"})
      end
    else
      conn
      |> put_status(:not_found)
      |> json(%{error: "invalid token"})
    end
  end

  # def show(conn, _params) do
  #   user = Guardian.Plug.current_resource(conn)
  #   conn |> render("user.json", user: user)
  # end

  def show(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{} = user} <- Accounts.update_user(user, user_params) do
      render(conn, "show.json", user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Accounts.get_user!(id)

    with {:ok, %User{}} <- Accounts.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
