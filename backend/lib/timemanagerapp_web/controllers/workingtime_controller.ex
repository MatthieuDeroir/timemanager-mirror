defmodule TimeManagerAppWeb.WorkingTimeController do
  use TimeManagerAppWeb, :controller
  use PhoenixSwagger

  alias TimeManagerApp.WorkingTimes
  alias TimeManagerAppWeb.Swagger.WorkingTimeSwagger

  action_fallback(TimeManagerAppWeb.FallbackController)

  Module.eval_quoted(__MODULE__, WorkingTimeSwagger.paths())

  def index(conn, %{"user_id" => user_id} = params) do
    start_datetime = Map.get(params, "start")
    end_datetime = Map.get(params, "end")

    workingtimes =
      case {start_datetime, end_datetime} do
        {nil, nil} ->
          WorkingTimes.list_workingtime_for_user(user_id)

        {start_datetime, nil} ->
          WorkingTimes.list_workingtime_for_user(user_id, start_datetime)

        {nil, end_datetime} ->
          WorkingTimes.list_workingtime_for_user(user_id, nil, end_datetime)

        {start_datetime, end_datetime} ->
          WorkingTimes.list_workingtime_for_user(user_id, start_datetime, end_datetime)
      end

    # This will return an empty array if there are no working times.
    json(conn, workingtimes)
  end

  def show(conn, %{"user_id" => user_id, "id" => id}) do
    case WorkingTimes.get_workingtime(user_id, id) do
      nil ->
        # Return an empty JSON object
        json(conn, [])

      workingtime ->
        json(conn, workingtime)
    end
  end

  def create(conn, %{"user_id" => user_id, "workingtime" => workingtime_params}) do
    case WorkingTimes.create_workingtime_for_user(user_id, workingtime_params) do
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
    case WorkingTimes.get_workingtime_by_id(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Working time not found"})

      workingtime ->
        case WorkingTimes.update_workingtime(workingtime, workingtime_params) do
          {:ok, updated_workingtime} ->
            json(conn, updated_workingtime)

          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{errors: changeset})
        end
    end
  end

  def delete(conn, %{"id" => id}) do
    case WorkingTimes.get_workingtime_by_id(id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Working time not found"})

      workingtime ->
        case WorkingTimes.delete_workingtime(workingtime) do
          {:ok, deleted_workingtime} ->
            conn
            |> put_status(:ok)
            |> json(deleted_workingtime)

          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{errors: changeset})
        end
    end
  end
end
