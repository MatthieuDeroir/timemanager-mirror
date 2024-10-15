defmodule TimeManagerApp.Repo.Migrations.CreateRoles do
  use Ecto.Migration

  def change do
    create table(:roles) do
      add(:name, :string, null: false, unique: true)

      timestamps(type: :utc_datetime)
    end
  end
end
