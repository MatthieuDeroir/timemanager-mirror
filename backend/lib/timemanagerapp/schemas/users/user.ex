defmodule TimeManagerApp.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Jason.Encoder,
           only: [
             :id,
             :firstname,
             :lastname,
             :address,
             :phone,
             :birthdate,
             :gender,
             :salary,
             :position,
             :start_date,
             :end_date,
             :username,
             :email,
             :role_id,
             :team_id,
             :inserted_at,
             :updated_at
           ]}
  schema "users" do
    field(:firstname, :string)
    field(:lastname, :string)
    field(:address, :string)
    field(:phone, :string)
    field(:birthdate, :date)
    field(:gender, :string)
    field(:salary, :float)
    field(:position, :string)
    field(:start_date, :date)
    field(:end_date, :date)
    field(:username, :string)
    field(:email, :string)
    field(:password_hash, :string)

    belongs_to(:role, TimeManagerApp.Roles.Role)
    belongs_to(:team, TimeManagerApp.Teams.Team)

    has_many(:clocks, TimeManagerApp.Clocks.Clock)
    has_many(:working_times, TimeManagerApp.WorkingTimes.WorkingTime)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [
      :firstname,
      :lastname,
      :address,
      :phone,
      :birthdate,
      :gender,
      :salary,
      :position,
      :start_date,
      :end_date,
      :username,
      :email,
      :password_hash,
      :role_id,
      :team_id
    ])
    |> validate_required([
      :username,
      :email,
      :password_hash
    ])
    |> validate_format(:email, ~r/^[\w.!#$%&'*+\/=?^`{|}~\-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-]{2,}$/,
      message: "is not a valid email"
    )
    |> unique_constraint(:email)
    |> foreign_key_constraint(:role_id)
    |> foreign_key_constraint(:team_id)
  end
end
