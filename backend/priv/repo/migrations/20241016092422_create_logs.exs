defmodule TimeManagerApp.Repo.Migrations.CreateLogs do
  use Ecto.Migration

  def change do
    create table(:logs) do
      add(:action, :string)
      add(:user_id, references(:users, on_delete: :delete_all), null: true)
      add(:message, :text)
      add(:level, :string)

      timestamps()
    end
  end
end
