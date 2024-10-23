defmodule TimeManagerAppWeb.UserTeamController do
  use TimeManagerAppWeb, :controller
  alias TimeManagerApp.UserTeams

  action_fallback(TimeManagerAppWeb.FallbackController)

  @doc """
  Adds a user to a team.

  ## Parameters

    - conn: The connection.
    - %{"team_id" => team_id, "user_id" => user_id}:
      - team_id: The ID of the team.
      - user_id: The ID of the user.

  ## Responses

    - 200: OK
    - 422: Unprocessable Entity
  """
  def add_user_to_team(conn, %{"team_id" => team_id, "user_id" => user_id}) do
    with {:ok, user} <- UserTeams.add_user_to_team(user_id, team_id) do
      json(conn, user)
    else
      {:error, reason} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: reason})
    end
  end

  @doc """
  Removes a user from a team.

  ## Parameters

    - conn: The connection.
    - %{"team_id" => team_id, "user_id" => user_id}:
      - team_id: The ID of the team.
      - user_id: The ID of the user.

  ## Responses

    - 200: OK
    - 422: Unprocessable Entity
  """
  def remove_user_from_team(conn, %{"team_id" => team_id, "user_id" => user_id}) do
    with {:ok, user} <- UserTeams.remove_user_from_team(user_id, team_id) do
      json(conn, user)
    else
      {:error, reason} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: reason})
    end
  end

  @doc """
  Lists users in a team.

  ## Parameters

    - conn: The connection.
    - %{"team_id" => team_id}:
      - team_id: The ID of the team.

  ## Responses

    - 200: OK
  """
  def list_users_in_team(conn, %{"team_id" => team_id}) do
    users = UserTeams.list_users_by_team(team_id)
    json(conn, users)
  end

  @doc """
  Lists teams a user belongs to.

  ## Parameters

    - conn: The connection.
    - %{"user_id" => user_id}:
      - user_id: The ID of the user.

  ## Responses

    - 200: OK
  """
  def list_teams_of_user(conn, %{"user_id" => user_id}) do
    teams = UserTeams.list_teams_by_user(user_id)
    json(conn, teams)
  end
end