defmodule TimeManagerApp.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :firstname, :string
      add :lastname, :string
      add :address, :string
      add :phone, :string
      add :birthdate, :date
      add :gender, :string
      add :salary, :float
      add :position, :string
      add :start_date, :date
      add :end_date, :date
      add :username, :string
      add :email, :string
      add :password_hash, :string
      add :role_id, references(:roles, on_delete: :nothing)
      add :team_id, references(:teams, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:users, [:role_id])
    create index(:users, [:team_id])
  end
end
