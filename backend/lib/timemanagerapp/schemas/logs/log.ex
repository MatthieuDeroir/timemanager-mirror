# lib/timemanagerapp/logs/log.ex
defmodule TimeManagerApp.Logs.Log do
  use Ecto.Schema
  import Ecto.Changeset

  schema "logs" do
    field(:action, :string)
    field(:message, :string)
    field(:level, :string)

    belongs_to(:user, TimeManagerApp.Users.User)

    timestamps()
  end

  @doc false
  def changeset(log, attrs) do
    log
    |> cast(attrs, [:action, :message, :level, :user_id])
    |> validate_required([:action, :message, :level])
    |> validate_length(:action, min: 1)
    |> validate_length(:message, min: 1)
    |> validate_inclusion(:level, ["info", "warning", "error"])
    |> foreign_key_constraint(:user_id)
  end
end

