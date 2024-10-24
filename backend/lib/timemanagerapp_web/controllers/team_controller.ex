defmodule TimeManagerAppWeb.TeamController do
  @moduledoc """
  Controller for managing teams in the Time Manager application.

  This controller provides actions to list, create, show, update, and delete teams.
  It also includes Swagger documentation for the Team schema.
  """

  use TimeManagerAppWeb, :controller
  use PhoenixSwagger

  alias TimeManagerApp.Teams
  alias TimeManagerApp.Teams.Team
  alias TimeManagerAppWeb.Swagger.TeamSwagger

  action_fallback(TimeManagerAppWeb.FallbackController)

  Module.eval_quoted(__MODULE__, TeamSwagger.paths())

  @doc """
  Lists all teams.

  ## Parameters
    - conn: The connection struct.
    - _params: A map of request parameters.

  ## Returns
    - Renders the index view with the list of teams.
  """
  def index(conn, _params) do
    teams = Teams.list_teams()
    json(conn, teams)
  end

  @doc """
  Creates a new team.

  ## Parameters
    - conn: The connection struct.
    - %{"team" => team_params}: A map containing the team parameters.

  ## Returns
    - Renders the show view with the newly created team.
  """
  def create(conn, %{"team" => team_params}) do
    with {:ok, %Team{} = team} <- Teams.create_team(team_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/teams/#{team.id}")
      |> render(:show, team: team)
    end
  end

  @doc """
  Shows details of a single team.

  ## Parameters
    - conn: The connection struct.
    - %{"id" => id}: A map containing the team ID.

  ## Returns
    - Renders the show view with the team details.
  """
  def show(conn, %{"id" => id}) do
    team = Teams.get_team!(id)
    json(conn, team)
  end

  @doc """
  Updates a team.

  ## Parameters
    - conn: The connection struct.
    - %{"id" => id, "team" => team_params}: A map containing the team ID and updated team parameters.

  ## Returns
    - Renders the show view with the updated team.
  """
  def update(conn, %{"id" => id, "team" => team_params}) do
    team = Teams.get_team!(id)

    with {:ok, %Team{} = team} <- Teams.update_team(team, team_params) do
      json(conn, team)
    end
  end

  @doc """
  Deletes a team.

  ## Parameters
    - conn: The connection struct.
    - %{"id" => id}: A map containing the team ID.

  ## Returns
    - Sends a no_content response.
  """
  def delete(conn, %{"id" => id}) do
    team = Teams.get_team!(id)

    with {:ok, %Team{}} <- Teams.delete_team(team) do
      send_resp(conn, :no_content, "")
    end
  end

  @doc """
  Returns Swagger definitions for the Team schema.

  ## Returns
    - Swagger definitions for the Team schema.
  """
  def swagger_definitions do
    TeamSwagger.swagger_definitions()
  end
end