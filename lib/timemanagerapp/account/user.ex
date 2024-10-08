defmodule TimeManagerApp.Account.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :username, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email])
    |> validate_required([:username, :email])
    |> validate_format(:email, ~r/^[\w.!#$%&'*+\/=?^`{|}~\-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-]{2,}$/,
      message: "is not a valid email"
    )
  end
end
