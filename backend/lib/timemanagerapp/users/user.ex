defmodule TimeManagerApp.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :address, :string
    field :birthdate, :date
    field :email, :string
    field :end_date, :date
    field :firstname, :string
    field :gender, :string
    field :lastname, :string
    field :password_hash, :string
    field :phone, :string
    field :position, :string
    field :salary, :float
    field :start_date, :date
    field :username, :string
    field :role_id, :id
    field :team_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:firstname, :lastname, :address, :phone, :birthdate, :gender, :salary, :position, :start_date, :end_date, :username, :email, :password_hash])
    |> validate_required([:firstname, :lastname, :address, :phone, :birthdate, :gender, :salary, :position, :start_date, :end_date, :username, :email, :password_hash])
  end
end
