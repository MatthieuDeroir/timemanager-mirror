defmodule TimeManagerApp.Teams.Team do
  use Ecto.Schema
  import Ecto.Changeset

  alias TimeManagerApp.Users.User

  @derive {Jason.Encoder, only: [:id, :name, :inserted_at, :updated_at, :users]}
  schema "teams" do
    field(:name, :string)

    many_to_many(
      :users,
      User,
      join_through: "users_teams",
      on_replace: :delete,
      unique: true
    )

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
    |> put_users_assoc(attrs)
  end

  defp put_users_assoc(changeset, attrs) do
    case Map.get(attrs, "user_ids") || Map.get(attrs, :user_ids) do
      nil ->
        changeset

      user_ids when is_list(user_ids) ->
        users = TimeManagerApp.Users.get_users_by_ids(user_ids)
        put_assoc(changeset, :users, users)

      _ ->
        changeset
    end
  end
end
