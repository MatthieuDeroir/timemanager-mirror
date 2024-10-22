# lib/timemanagerapp/teams.ex
defmodule TimeManagerApp.Teams do
  @moduledoc """
  The Teams context.
  """
  import Ecto.Query, warn: false
  alias TimeManagerApp.Repo
  alias TimeManagerApp.Teams.Team
  alias TimeManagerApp.Users
  alias TimeManagerApp.Users.User

  def list_teams do
    Repo.all(Team) |> Repo.preload(:users)
  end

  def get_team!(id) do
    Repo.get!(Team, id) |> Repo.preload(:users)
  end

  def create_team(attrs \\ %{}) do
    %Team{}
    |> Team.changeset(attrs)
    |> Repo.insert()
  end

  def update_team(%Team{} = team, attrs) do
    team
    |> Repo.preload(:users)
    |> Team.changeset(attrs)
    |> Repo.update()
  end

  def delete_team(%Team{} = team) do
    Repo.delete(team)
  end

  @doc """
  Returns the list of teams that a user belongs to.
  """
  def list_teams_by_user_id(user_id) do
    Repo.all(
      from(t in Team,
        join: u in assoc(t, :users),
        where: u.id == ^user_id
      )
    )
  end

  @doc """
  Gets teams by a list of IDs.
  """
  def get_teams_by_ids(team_ids) when is_list(team_ids) do
    Repo.all(from(t in Team, where: t.id in ^team_ids, preload: [:users]))
  end

  @doc """
  Adds a user to a team.
  """
  def add_user_to_team(team_id, user_id) do
    team = get_team!(team_id)
    user = Users.get_user(user_id)

    team
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:users, [user | team.users])
    |> Repo.update()
  end

  @doc """
  Removes a user from a team.
  """
  def remove_user_from_team(team_id, user_id) do
    team = get_team!(team_id)

    updated_users = Enum.reject(team.users, fn u -> u.id == user_id end)

    team
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.put_assoc(:users, updated_users)
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking team changes.
  """
  def change_team(%Team{} = team, attrs \\ %{}) do
    Team.changeset(team, attrs)
  end
end
