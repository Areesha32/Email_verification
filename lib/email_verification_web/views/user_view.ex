defmodule EmailVerificationWeb.UserView do
  use EmailVerificationWeb, :view
  alias EmailVerificationWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      name: user.name,
      email: user.email,
      hash_password: user.hash_password
    }
  end
  def render("jwt.json", %{jwt: jwt}) do
    %{jwt: jwt}
  end
end