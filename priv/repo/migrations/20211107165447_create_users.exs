defmodule EmailVerification.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
    	add :name, :string
  		add :email, :string
  		add :token, :string
  		add :email_verified, :boolean
  		add :hash_password, :string

      timestamps()
    end
    create unique_index(:users, [:email])
  end
end
