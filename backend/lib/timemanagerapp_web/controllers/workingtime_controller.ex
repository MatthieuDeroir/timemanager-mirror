defmodule TimeManagerAppWeb.WorkingTimeController do
  use TimeManagerAppWeb, :controller

  alias TimeManagerApp.Time

  action_fallback(TimeManagerAppWeb.FallbackController)

  def index(conn, %{"user_id" => user_id} = params) do
    start_datetime = Map.get(params, "start")
    end_datetime = Map.get(params, "end")

    workingtimes =
      case {start_datetime, end_datetime} do
        {nil, nil} ->
          Time.list_workingtime_for_user(user_id)

        {start_datetime, nil} ->
          Time.list_workingtime_for_user(user_id, start_datetime)

        {nil, end_datetime} ->
          Time.list_workingtime_for_user(user_id, nil, end_datetime)

        {start_datetime, end_datetime} ->
          Time.list_workingtime_for_user(user_id, start_datetime, end_datetime)
      end

    if length(workingtimes) > 0 do
      json(conn, workingtimes)
    else
      conn
      |> put_status(:not_found)
      |> json(%{error: "No working times found"})
    end
  end

  def show(conn, %{"user_id" => user_id, "id" => id}) do
    case Time.get_workingtime(user_id, id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Working time not found"})

      workingtime ->
        json(conn, workingtime)
    end
  end

  def create(conn, %{"user_id" => user_id, "workingtime" => workingtime_params}) do
    case Time.create_workingtime_for_user(user_id, workingtime_params) do
      {:ok, workingtime} ->
        conn
        |> put_status(:created)
        |> json(workingtime)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: changeset})
    end
  end

  def update(conn, %{"id" => id, "workingtime" => workingtime_params}) do
    workingtime = Time.get_workingtime(id)

    case Time.update_workingtime(workingtime, workingtime_params) do
      {:ok, updated_workingtime} ->
        json(conn, updated_workingtime)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: changeset})
    end
  end

  def delete(conn, %{"id" => id}) do
    workingtime = Time.get_workingtime(id)

    with {:ok, deleted_workingtime} <- Time.delete_workingtime(workingtime) do
      conn
      |> put_status(:ok)
      |> json(deleted_workingtime)
    end
  end
end
