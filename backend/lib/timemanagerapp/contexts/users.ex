defmodule TimeManagerApp.Users do
  @moduledoc """
  The Account context.
  """

  import Ecto.Query, warn: false
  alias TimeManagerApp.Repo

  alias TimeManagerApp.Users.User

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    Repo.all(User)
  end

  @doc """
  Returns the list of users filtered by email and username using partial matching.

  ## Examples

      iex> list_users_by_email_and_username("ma", "ma")
      [%User{}, ...]

  """
  def list_users_by_email_and_username(email, username) do
    Repo.all(
      from(u in User,
        where: ilike(u.email, ^"%#{email}%") and ilike(u.username, ^"%#{username}%")
      )
    )
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user(id), do: Repo.get(User, id)

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  @doc """
  Returns the list of users filtered by email using partial matching.

  ## Examples

      iex> list_users_by_email("ma")
      [%User{}, ...]

  """
  def list_users_by_email(email) do
    Repo.all(from(u in User, where: ilike(u.email, ^"%#{email}%")))
  end

  @doc """
  Returns the list of users filtered by username using partial matching.

  ## Examples

      iex> list_users_by_username("ma")
      [%User{}, ...]

  """
  def list_users_by_username(username) do
    Repo.all(from(u in User, where: ilike(u.username, ^"%#{username}%")))
  end

  @doc """
  returns the team id of a user
  """
  def get_users_team(user_id) do
    Repo.get(User, user_id).team_id
  end

  @doc """
  Return the list of users that are part of a specific team
  """

  def list_users_by_team_id(team_id) do
    Repo.all(from(u in User, where: u.team_id == ^team_id))
  end
end