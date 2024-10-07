defmodule TimeManagerApp.Repo.Migrations.CreateWorkingTime do
  use Ecto.Migration

  def change do
    create table(:working_time) do
      add :start, :utc_datetime
      add :end, :utc_datetime
      add :user_id, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:working_time, [:user_id])
  end
end
