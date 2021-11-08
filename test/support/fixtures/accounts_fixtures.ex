defmodule EmailVerification.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `EmailVerification.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "some email",
        hash_password: "some hash_password",
        name: "some name"
      })
      |> EmailVerification.Accounts.create_user()

    user
  end
end
