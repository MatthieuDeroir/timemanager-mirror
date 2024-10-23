defmodule TimeManagerApp.UserTeams do
  @moduledoc """
  The UserTeams context handles the association between users and teams.
  """

  import Ecto.Query, warn: false
  alias TimeManagerApp.Repo
  alias TimeManagerApp.Users
  alias TimeManagerApp.Teams

  @doc """
  Adds a user to a team without circular preloading.
  """
  def add_user_to_team(user_id, team_id) do
    user = Users.get_user_with_teams(user_id)
    team = Teams.get_team_with_users(team_id)

    if Enum.any?(user.teams, &(&1.id == team.id)) do
      {:error, "User is already a member of the team"}
    else
      user
      |> Ecto.Changeset.change()
      |> Ecto.Changeset.put_assoc(:teams, [team | user.teams])
      |> Repo.update()
    end
  end

  @doc """
  Removes a user from a team.
  """
  def remove_user_from_team(user_id, team_id) do
    user = Users.get_user_with_teams(user_id)

    updated_teams = Enum.reject(user.teams, fn t -> t.id == team_id end)

    user
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:teams, updated_teams)
    |> Repo.update()
  end

  @doc """
  Lists users by team without circular preloading.
  """
  def list_users_by_team(team_id) do
    Repo.all(
      from u in Users.User,
      join: t in assoc(u, :teams),
      where: t.id == ^team_id,
      preload: [:teams]
    )
  end

  @doc """
  Lists teams by user without circular preloading.
  """
  def list_teams_by_user(user_id) do
    Repo.all(
      from t in Teams.Team,
      join: u in assoc(t, :users),
      where: u.id == ^user_id,
      preload: [:users]
    )
  end
end
