defmodule TimeManagerAppWeb.UserController do
  use TimeManagerAppWeb, :controller
  use PhoenixSwagger

  alias TimeManagerApp.Users
  alias TimeManagerApp.Users.User
  alias TimeManagerAppWeb.Swagger.UserSwagger
  alias TimeManagerApp.Repo
  alias TimeManagerApp.Teams

  action_fallback(TimeManagerAppWeb.FallbackController)

  # Inject paths from UserSwagger
  Module.eval_quoted(__MODULE__, UserSwagger.paths())

  def index(conn, params) do
    users =
      case {Map.get(params, "email"), Map.get(params, "username")} do
        {nil, nil} ->
          Users.list_users()

        {email, nil} ->
          Users.list_users_by_email(email)

        {nil, username} ->
          Users.list_users_by_username(username)

        {email, username} ->
          Users.list_users_by_email_and_username(email, username)
      end

    json(conn, users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Users.create_user(user_params) do
      user = Repo.preload(user, :teams)

      conn
      |> put_status(:created)
      |> json(user)
    end
  end

  def show(conn, %{"id" => id}) do
    case Users.get_user(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "User not found"})

      user ->
        json(conn, user)
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    case Users.get_user(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "User not found"})

      user ->
        with {:ok, %User{} = updated_user} <- Users.update_user(user, user_params) do
          json(conn, updated_user)
        end
    end
  end

  def delete(conn, %{"id" => id}) do
    case Users.get_user(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "User not found"})

      user ->
        with {:ok, %User{}} <- Users.delete_user(user) do
          send_resp(conn, :no_content, "")
        end
    end
  end

  @doc """
  Returns a list of users that share the same team.
  """
  def index_team(conn, %{"team_id" => team_id}) do
    users = Users.list_users_by_team_id(team_id)
    json(conn, users)
  end

  @doc """
  Returns the teams associated with a user.
  """
  def user_teams(conn, %{"user_id" => user_id}) do
    teams = Teams.list_teams_by_user_id(user_id)
    json(conn, teams)
  end

  # Swagger schema for User
  def swagger_definitions do
    UserSwagger.swagger_definitions()
  end
end
