defmodule TimeManagerAppWeb.UserController do
  use TimeManagerAppWeb, :controller

  alias TimeManagerApp.Account
  alias TimeManagerApp.Account.User

  action_fallback TimeManagerAppWeb.FallbackController

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
      |> put_resp_header("location", ~p"/api/users/#{user}")
      |> render(:show, user: user)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Account.get_user!(id)
    render(conn, :show, user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Account.get_user!(id)

    with {:ok, %User{} = user} <- Account.update_user(user, user_params) do
      render(conn, :show, user: user)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Account.get_user!(id)

    with {:ok, %User{}} <- Account.delete_user(user) do
      send_resp(conn, :no_content, "")
    end
  end
end
