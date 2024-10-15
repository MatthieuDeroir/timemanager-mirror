defmodule TimeManagerAppWeb.UserJSON do
  alias TimeManagerApp.Users.User

  @doc """
  Renders a list of users.
  """
  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user))}
  end

  @doc """
  Renders a single user.
  """
  def show(%{user: user}) do
    %{data: data(user)}
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      firstname: user.firstname,
      lastname: user.lastname,
      address: user.address,
      phone: user.phone,
      birthdate: user.birthdate,
      gender: user.gender,
      salary: user.salary,
      position: user.position,
      start_date: user.start_date,
      end_date: user.end_date,
      username: user.username,
      email: user.email,
      password_hash: user.password_hash
    }
  end
end
