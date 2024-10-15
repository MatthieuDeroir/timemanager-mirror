defmodule TimeManagerApp.Repo.Migrations.CreateWorkingTime do
  use Ecto.Migration

  def change do
    create table(:working_times) do
      add(:start, :utc_datetime, null: false)
      add(:end, :utc_datetime, null: false)
      add(:user_id, references(:users, on_delete: :delete_all), null: false)

      timestamps(type: :utc_datetime)
    end

    create(index(:working_times, [:user_id]))
    create(index(:working_times, [:start]))
    create(index(:working_times, [:end]))
  end
end
