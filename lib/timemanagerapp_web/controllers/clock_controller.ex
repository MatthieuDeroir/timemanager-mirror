defmodule TimeManagerAppWeb.ClockController do
  use TimeManagerAppWeb, :controller

  # Explicitly alias Routes
  alias TimeManagerAppWeb.Router.Helpers, as: Routes

  alias TimeManagerApp.Time
  alias TimeManagerApp.Time.Clock

  action_fallback TimeManagerAppWeb.FallbackController

  def index(conn, %{"user_id" => user_id}) do
    clocks = Time.list_clocks_for_user(user_id)

    render(conn, "index.json", clocks: clocks)
  end


  def create(conn, %{"user_id" => user_id, "clocks" => clock_params}) do
    case Time.create_clock_for_user(user_id, clock_params) do
      {:ok, clock} ->
        conn
        |> put_status(:created)
        |> render("show.json", clock: clock)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(TimeManagerAppWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"user_id" => user_id, "id" => id}) do
    case Time.get_clock(user_id, id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> render(TimeManagerAppWeb.ErrorView, "404.json", message: "Clock not found")

      clock ->
        render(conn, "show.json", clock: clock)
    end
  end
end
