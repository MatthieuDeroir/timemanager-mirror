defmodule TimeManagerAppWeb.TeamController do
  use TimeManagerAppWeb, :controller
  use PhoenixSwagger

  alias TimeManagerApp.Teams
  alias TimeManagerApp.Teams.Team
  # Added alias for Repo
  alias TimeManagerApp.Repo
  alias TimeManagerAppWeb.Swagger.TeamSwagger

  action_fallback(TimeManagerAppWeb.FallbackController)

  Module.eval_quoted(__MODULE__, TeamSwagger.paths())

  def index(conn, _params) do
    teams = Teams.list_teams()
    render(conn, :index, teams: teams)
  end

  def create(conn, %{"team" => team_params}) do
    with {:ok, %Team{} = team} <- Teams.create_team(team_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/teams/#{team.id}")
      |> render(:show, team: team)
    end
  end

  def show(conn, %{"id" => id}) do
    team = Teams.get_team!(id)
    render(conn, :show, team: team)
  end

  def update(conn, %{"id" => id, "team" => team_params}) do
    team = Teams.get_team!(id)

    with {:ok, %Team{} = team} <- Teams.update_team(team, team_params) do
      render(conn, :show, team: team)
    end
  end

  def delete(conn, %{"id" => id}) do
    team = Teams.get_team!(id)

    # Changed from {:ok, %Team{}} to avoid unused variable
    with {:ok, %Team{}} <- Teams.delete_team(team) do
      send_resp(conn, :no_content, "")
    end
  end

  @doc """
  Returns a list of teams that a user belongs to.
  """
  def user_teams(conn, %{"user_id" => user_id}) do
    teams = Teams.list_teams_by_user_id(user_id)
    render(conn, :index, teams: teams)
  end

  @doc """
  Adds a user to a team.
  """
  def add_user(conn, %{"team_id" => team_id, "user_id" => user_id}) do
    # Removed binding to 'team'
    with {:ok, %Team{}} <- Teams.add_user_to_team(team_id, user_id) do
      team = Teams.get_team!(team_id) |> Repo.preload(:users)

      json(conn, team)
    else
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(TimeManagerAppWeb.ChangesetView)
        |> render("error.json", changeset: changeset)
    end
  end

  @doc """
  Removes a user from a team.
  """
  def remove_user(conn, %{"team_id" => team_id, "user_id" => user_id}) do
    # Removed binding to 'team'
    with {:ok, %Team{}} <- Teams.remove_user_from_team(team_id, user_id) do
      team = Teams.get_team!(team_id) |> Repo.preload(:users)

      json(conn, team)
    else
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(TimeManagerAppWeb.ChangesetView)
        |> render("error.json", changeset: changeset)
    end
  end

  @doc """
  Returns a list of users that belong to a team.
  """
  def team_users(conn, %{"team_id" => team_id}) do
    team = Teams.get_team!(team_id) |> Repo.preload(users: :teams)
    users = team.users
    json(conn, users)
  end
end
