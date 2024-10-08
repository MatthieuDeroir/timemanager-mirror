defmodule TimeManagerAppWeb.WorkingTimeController do
  use TimeManagerAppWeb, :controller

  alias TimeManagerApp.Time
  alias TimeManagerApp.Time.WorkingTime

  action_fallback TimeManagerAppWeb.FallbackController

  def index(conn, %{"user_id" => user_id} = params) do
    start_datetime = Map.get(params, "start")
    end_datetime = Map.get(params, "end")

    working_times = Time.list_working_time_for_user(user_id, start_datetime, end_datetime)

    if length(working_times) > 0 do
      # Pass the expected key `working_time`, not `working_times`
      render(conn, "index.json", working_time: working_times)
    else
      conn
      |> put_status(:not_found)
      |> render(TimeManagerAppWeb.ErrorView, "404.json", message: "No working times found.")
    end
  end



  def show(conn, %{"user_id" => _user_id, "id" => id}) do
    working_time = Time.get_working_time!(id)
    render(conn, "show.json", working_time: working_time)
  end

  def create(conn, %{"user_id" => user_id, "working_time" => working_time_params}) do
    case Time.create_working_time_for_user(user_id, working_time_params) do
      {:ok, working_time} ->
        conn
        |> put_status(:created)
        |> render("show.json", working_time: working_time)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(TimeManagerAppWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "working_time" => working_time_params}) do
    working_time = Time.get_working_time!(id)

    case Time.update_working_time(working_time, working_time_params) do
      {:ok, updated_working_time} ->
        render(conn, "show.json", working_time: updated_working_time)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(TimeManagerAppWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    working_time = Time.get_working_time!(id)

    with {:ok, deleted_working_time} <- Time.delete_working_time(working_time) do
      # Return the deleted working time with a 200 OK status
      conn
      |> put_status(:ok)
      |> render("show.json", working_time: deleted_working_time)
    end
  end
end
