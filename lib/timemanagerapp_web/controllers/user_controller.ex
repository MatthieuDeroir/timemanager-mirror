defmodule TimeManagerAppWeb.UserController do
  use TimeManagerAppWeb, :controller

  alias TimeManagerApp.Repo

  action_fallback TimeManagerAppWeb.FallbackController

  @doc """
  Lists all users.
  """
  def index(conn, _params) do
    users = Repo.all(User)
    render(conn, "index.json", users: users)
  end

  @doc """
  Shows a specific user by ID.
  """
  def show(conn, %{"id" => id}) do
    case Repo.get(User, id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> render(TimeManagerAppWeb.ErrorView, "404.json")

      user ->
        render(conn, "show.json", user: user)
    end
  end
end
