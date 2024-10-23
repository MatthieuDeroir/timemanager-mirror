defmodule TimeManagerAppWeb.UserController do
  use TimeManagerAppWeb, :controller
  use PhoenixSwagger

  alias TimeManagerApp.Users
  alias TimeManagerApp.Users.User
  alias TimeManagerAppWeb.Swagger.UserSwagger
  alias TimeManagerApp.Repo

  action_fallback(TimeManagerAppWeb.FallbackController)

  # Inject paths from UserSwagger
  Module.eval_quoted(__MODULE__, UserSwagger.paths())

  @doc """
  Lists all users, optionally filtered by email and/or username.

  ## Parameters
    - conn: The connection.
    - params: The query parameters containing optional email and username filters.

  ## Examples
      GET /users

      GET /users?email=johndoe@example.com

      GET /users?username=johndoe

      GET /users?email=johndoe@example.com&username=johndoe
  """
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

  @doc """
  Creates a new user and returns it with the 'teams' relationship preloaded.

  ## Parameters
    - conn: The connection.
    - params: The request body containing user data.

  ## Examples
      POST /users
  """
  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Users.create_user(user_params) do
      user = Repo.preload(user, :teams)

      conn
      |> put_status(:created)
      |> json(user)
    end
  end

  @doc """
  Shows a user by ID. Returns a 404 status if the user is not found.

  ## Parameters
    - conn: The connection.
    - params: The path parameters containing user ID.

  ## Examples
      GET /users/:id
  """
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

  @doc """
  Updates a user by ID with the given parameters. Returns a 404 status if the user is not found.

  ## Parameters
    - conn: The connection.
    - params: The path parameters containing user ID and the request body containing user data.

  ## Examples
      PUT /users/:id
  """
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

  @doc """
  Deletes a user by ID. Returns a 404 status if the user is not found.

  ## Parameters
    - conn: The connection.
    - params: The path parameters containing user ID.

  ## Examples
      DELETE /users/:id
  """
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

  # Swagger schema for User
  def swagger_definitions do
    UserSwagger.swagger_definitions()
  end
end