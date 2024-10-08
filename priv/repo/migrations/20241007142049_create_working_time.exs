defmodule TimeManagerApp.Repo.Migrations.CreateWorkingTime do
  use Ecto.Migration

  def change do
    create table(:working_time) do
      add :start, :utc_datetime, null: false
      add :end, :utc_datetime, null: false
      add :user_id, references(:users, on_delete: :nothing), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:working_time, [:user_id])
  end
end
