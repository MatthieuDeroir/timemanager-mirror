defmodule TimeManagerApp.Repo.Migrations.CreateWorkingTime do
  use Ecto.Migration

  def change do
    create table(:workingtime) do
      add(:start, :utc_datetime, null: false)
      add(:end, :utc_datetime, null: false)
      add(:type, :string, null: false)
      add(:user_id, references(:users, on_delete: :delete_all), null: false)

      timestamps(type: :utc_datetime)
    end

    create(index(:workingtime, [:user_id]))
  end
end
