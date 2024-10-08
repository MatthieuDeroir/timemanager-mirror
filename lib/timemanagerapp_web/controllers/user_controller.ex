defmodule TimeManagerAppWeb.UserController do
  use TimeManagerAppWeb, :controller
  use PhoenixSwagger

  alias TimeManagerApp.Account
  alias TimeManagerApp.Account.User
  alias TimeManagerAppWeb.Swagger.UserSwagger

  action_fallback TimeManagerAppWeb.FallbackController

  # Inject paths from UserSwagger
  Module.eval_quoted(__MODULE__, UserSwagger.paths())

  # GET /api/users?email=XXX&username=YYY
  def index(conn, params) do
    users =
      case {Map.get(params, "email"), Map.get(params, "username")} do
        {nil, nil} ->
          Account.list_users()

        {email, nil} ->
          Account.list_users_by_email(email)

        {nil, username} ->
          Account.list_users_by_username(username)

        {email, username} ->
          Account.list_users_by_email_and_username(email, username)
      end

    render(conn, :index, users: users)
  end

  def create(conn, %{"user" => user_params}) do
    with {:ok, %User{} = user} <- Account.create_user(user_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/users/#{user.id}")
      |> render(:show, user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    case Account.get_user(id) do
      nil ->
        send_resp(conn, :no_content, "")

      user ->
        render(conn, :show, user: user)
    end
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    case Account.get_user(id) do
      nil ->
        send_resp(conn, :no_content, "")

      user ->
        with {:ok, %User{} = updated_user} <- Account.update_user(user, user_params) do
          render(conn, :show, user: updated_user)
        end
    end
  end

  def delete(conn, %{"id" => id}) do
    case Account.get_user(id) do
      nil ->
        send_resp(conn, :no_content, "")

      user ->
        with {:ok, %User{}} <- Account.delete_user(user) do
          send_resp(conn, :no_content, "")
        end
    end
  end

  # Swagger schema for User
  def swagger_definitions do
    UserSwagger.swagger_definitions()
  end
end
