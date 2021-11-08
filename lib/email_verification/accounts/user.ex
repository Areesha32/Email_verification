defmodule EmailVerification.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  import Comeonin.Bcrypt, only: [hashpwsalt: 1]

  alias EmailVerification.Accounts.User
  alias EmailVerification.Repo

  schema "users" do
    field :email, :string
		field :name, :string
		field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
		field :hash_password, :string
		field :email_verified, :boolean
		field :token, :string

		timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email, :password, :password_confirmation])
    |> validate_required([:name, :email, :password, :password_confirmation])
    # Check that email is valid
    |> validate_format(:email, ~r/@/)
    # Check that password length is >= 8
    |> validate_length(:password, min: 8)
    # Check that password === password_confirmation
    |> validate_confirmation(:password)
    |> unique_constraint(:email)
    |> put_token()
    |> put_password_hash # Add put_password_hash to changeset pipeline
  end

  defp put_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}}
        ->
          put_change(changeset, :hash_password, Comeonin.Bcrypt.hashpwsalt(pass))
      _ ->
          changeset
    end
  end

  defp put_token(changeset) do
		case changeset do
			%Ecto.Changeset{valid?: true} ->
				put_change(changeset, :token, SecureRandom.urlsafe_base64())
			_ ->
				changeset
		end
	end


  def verify_email(user) do
    user
    |> User.verify_changeset()
    |> Repo.update()
  end

	def verify_changeset(%User{} = user, params \\ %{}) do
		user
		|> cast(params, [])
		|> put_verify_email()
	end

	defp put_verify_email(changeset) do
		case changeset do
			%Ecto.Changeset{valid?: true} ->
				put_change(changeset, :email_verified, true)
			_ ->
				changeset
		end
	end
end
