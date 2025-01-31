defmodule TimeManagerApp.WorkingTimes.WorkingTime do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder, only: [:id, :start, :end, :user_id, :inserted_at, :updated_at]}
  schema "workingtime" do
    field(:start, :utc_datetime)
    field(:end, :utc_datetime)
    field(:type, :string)
    belongs_to(:user, TimeManagerApp.Users.User)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(working_time, attrs) do
    working_time
    |> cast(attrs, [:start, :end, :user_id])
    |> validate_required([:start, :end, :user_id])
    # Custom validation for start/end time
    |> validate_time_order()
  end

  defp validate_time_order(changeset) do
    start_time = get_field(changeset, :start)
    end_time = get_field(changeset, :end)

    if start_time && end_time && start_time >= end_time do
      add_error(changeset, :end, "must be after start time and different")
    else
      changeset
    end
  end
end
