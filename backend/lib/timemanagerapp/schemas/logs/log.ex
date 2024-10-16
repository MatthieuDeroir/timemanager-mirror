defmodule TimeManagerApp.Logs.Log do
  use Ecto.Schema
  import Ecto.Changeset

  schema "logs" do
    field(:action, :string)
    field(:message, :string)
    field(:level, :string)
    field(:user_id, :id)

    timestamps()
  end

  @doc false
  def changeset(log, attrs) do
    log
    |> cast(attrs, [:action, :message, :level, :user_id])
  end
end
