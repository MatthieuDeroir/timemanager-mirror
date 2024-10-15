defmodule TimeManagerApp.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:firstname, :string)
      add(:lastname, :string)
      add(:address, :string)
      add(:phone, :string)
      add(:birthdate, :date)
      add(:gender, :string)
      add(:salary, :float)
      add(:position, :string)
      add(:start_date, :date)
      add(:end_date, :date)
      add(:username, :string, null: false)
      add(:email, :string, null: false)
      add(:password_hash, :string, null: false)
      add(:role_id, references(:roles, on_delete: :nothing))
      add(:team_id, references(:teams, on_delete: :nilify_all))

      timestamps(type: :utc_datetime)
    end

    create(unique_index(:users, [:email]))
    create(index(:users, [:role_id]))
    create(index(:users, [:team_id]))
  end
end
