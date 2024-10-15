defmodule TimeManagerApp.Clocks.Clock do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :time, :status, :user_id, :inserted_at, :updated_at]}
  schema "clocks" do
    field(:time, :utc_datetime)
    field(:status, :string, default: "pending")

    belongs_to(:user, TimeManagerApp.Users.User)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(clock, attrs) do
    clock
    |> cast(attrs, [:time, :status, :user_id])
    |> validate_required([:time, :status, :user_id])
    |> validate_inclusion(:status, ["pending", "approved", "rejected"])
    |> foreign_key_constraint(:user_id)
  end
end
