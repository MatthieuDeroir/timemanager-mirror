defmodule TimeManagerApp.Repo.Migrations.CreateClocks do
  use Ecto.Migration

  def change do
    create table(:clocks) do
      add(:time, :utc_datetime, null: false)
      add(:status, :string, default: "pending", null: false)
      add(:user_id, references(:users, on_delete: :delete_all), null: false)

      timestamps(type: :utc_datetime)
    end

    create(index(:clocks, [:user_id]))
    create(index(:clocks, [:status]))
  end
end
