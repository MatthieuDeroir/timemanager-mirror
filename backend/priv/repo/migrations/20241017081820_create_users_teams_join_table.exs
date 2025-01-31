defmodule TimeManagerApp.Repo.Migrations.CreateUsersTeamsJoinTable do
  use Ecto.Migration

  def change do
    create table(:users_teams, primary_key: false) do
      add(:user_id, references(:users, on_delete: :delete_all), null: false)
      add(:team_id, references(:teams, on_delete: :delete_all), null: false)
    end

    create(unique_index(:users_teams, [:user_id, :team_id]))
    create(index(:users_teams, [:team_id]))
  end
end
