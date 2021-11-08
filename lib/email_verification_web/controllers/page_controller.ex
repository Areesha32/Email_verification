defmodule EmailVerificationWeb.PageController do
  use EmailVerificationWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
