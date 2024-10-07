defmodule TimeManagerApp.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :first_name, :string
      add :last_name, :string
      add :inserted_at, :utc_datetime
      add :created_at, :utc_datetime
    end
  end
end
