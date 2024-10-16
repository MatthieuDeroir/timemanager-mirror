defmodule TimeManagerApp.Repo.Migrations.CreateTeams do
  use Ecto.Migration

  def change do
    create table(:teams) do
      add(:name, :string, null: false, unique: true)

      timestamps(type: :utc_datetime)
    end
  end
end