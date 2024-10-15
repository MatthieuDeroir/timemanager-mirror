defmodule TimeManagerApp.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:firstname, :string, null: false)
      add(:lastname, :string, null: false)
      add(:address, :string, null: false)
      add(:phone, :string, null: false)
      add(:birthdate, :date, null: false)
      add(:gender, :string, null: false)
      add(:salary, :float, null: false)
      add(:position, :string, null: false)
      add(:start_date, :date, null: false)
      add(:end_date, :date, null: false)
      add(:username, :string, null: false)
      add(:email, :string, null: false)
      add(:password_hash, :string, null: false)
      add(:role_id, references(:roles, on_delete: :nothing), null: false)
      add(:team_id, references(:teams, on_delete: :nilify_all), null: false)

      timestamps(type: :utc_datetime)
    end

    create(unique_index(:users, [:email]))
    create(index(:users, [:role_id]))
    create(index(:users, [:team_id]))
  end
end
