defmodule TimeManagerApp.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :created_at, :utc_datetime
    field :first_name, :string
    field :inserted_at, :utc_datetime
    field :last_name, :string
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:first_name, :last_name, :inserted_at, :created_at])
    |> validate_required([:first_name, :last_name, :inserted_at, :created_at])
  end
end
