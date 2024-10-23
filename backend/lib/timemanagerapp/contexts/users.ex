defmodule TimeManagerApp.Users do
  @moduledoc """
  The Users context.
  """

  import Ecto.Query, warn: false
  alias TimeManagerApp.Repo
  alias TimeManagerApp.Users.User
  alias TimeManagerApp.Teams

  def list_users do
    Repo.all(User) |> Repo.preload(:teams)
  end

  def get_user_with_teams(user_id) do
    Repo.get(User, user_id) |> Repo.preload(:teams)
  end


  def get_user_with_full_teams(user_id) do
    Repo.get(User, user_id) |> Repo.preload(teams: [:users])
  end




  def list_users_by_email_and_username(email, username) do
    Repo.all(
      from(u in User,
        where: ilike(u.email, ^"%#{email}%") and ilike(u.username, ^"%#{username}%"),
        preload: [teams: :users]
      )
    )
  end

  @doc """
  Gets a single user.
  """
  def get_user(id) do
    Repo.get(User, id)
    |> Repo.preload(teams: [:users])
  end

  @doc """
  Creates a user.
  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.create_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.
  """

  def update_user(%User{} = user, attrs) do
    user
    |> Repo.preload(:teams)
    |> User.update_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.
  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.
  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  def list_users_by_email(email) do
    Repo.all(from(u in User, where: ilike(u.email, ^"%#{email}%"), preload: [teams: :users]))
  end

  def list_users_by_username(username) do
    Repo.all(
      from(u in User, where: ilike(u.username, ^"%#{username}%"), preload: [teams: :users])
    )
  end





  @doc """
  Gets users by a list of IDs.
  """
  def get_users_by_ids(user_ids) when is_list(user_ids) do
    Repo.all(from(u in User, where: u.id in ^user_ids))
  end

  def authenticate_user(email, password) do
    user = Repo.get_by(User, email: email)

    cond do
      user && Pbkdf2.verify_pass(password, user.password_hash) ->
        user = Repo.preload(user, :teams)
        {:ok, user}

      user ->
        {:error, "Invalid password"}

      true ->
        {:error, "User not found"}
    end
  end
end
