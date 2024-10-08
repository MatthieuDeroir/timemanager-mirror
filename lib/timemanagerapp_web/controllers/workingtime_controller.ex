defmodule TimeManagerAppWeb.WorkingTimeController do
  use TimeManagerAppWeb, :controller

  alias TimeManagerApp.Time
  alias TimeManagerApp.Time.WorkingTime

  action_fallback TimeManagerAppWeb.FallbackController

  def index(conn, %{"user_id" => user_id} = params) do
    start_datetime = Map.get(params, "start")
    end_datetime = Map.get(params, "end")

    workingtimes = Time.list_workingtime_for_user(user_id, start_datetime, end_datetime)

    if length(workingtimes) > 0 do
      # Pass the expected key `workingtime`, not `workingtimes`
      render(conn, "index.json", workingtime: workingtimes)
    else
      conn
      |> put_status(:not_found)
      |> render(TimeManagerAppWeb.ErrorView, "404.json", message: "No working times found.")
    end
  end

  def show(conn, %{"user_id" => _user_id, "id" => id}) do
    workingtime = Time.get_workingtime!(id)
    render(conn, "show.json", workingtime: workingtime)
  end

  def create(conn, %{"user_id" => user_id, "workingtime" => workingtime_params}) do
    case Time.create_workingtime_for_user(user_id, workingtime_params) do
      {:ok, workingtime} ->
        conn
        |> put_status(:created)
        |> render("show.json", workingtime: workingtime)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(TimeManagerAppWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "workingtime" => workingtime_params}) do
    workingtime = Time.get_workingtime!(id)

    case Time.update_workingtime(workingtime, workingtime_params) do
      {:ok, updated_workingtime} ->
        render(conn, "show.json", workingtime: updated_workingtime)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(TimeManagerAppWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    workingtime = Time.get_workingtime!(id)

    with {:ok, deleted_workingtime} <- Time.delete_workingtime(workingtime) do
      # Return the deleted working time with a 200 OK status
      conn
      |> put_status(:ok)
      |> render("show.json", workingtime: deleted_workingtime)
    end
  end
end
