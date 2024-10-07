defmodule TimeManagerAppWeb.WorkingTimeController do
  use TimeManagerAppWeb, :controller

  alias TimeManagerApp.Time
  alias TimeManagerApp.Time.WorkingTime

  action_fallback TimeManagerAppWeb.FallbackController

  def index(conn, _params) do
    working_time = Time.list_working_time()
    render(conn, :index, working_time: working_time)
  end

  def create(conn, %{"working_time" => working_time_params}) do
    with {:ok, %WorkingTime{} = working_time} <- Time.create_working_time(working_time_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/working_time/#{working_time}")
      |> render(:show, working_time: working_time)
    end
  end

  def show(conn, %{"id" => id}) do
    working_time = Time.get_working_time!(id)
    render(conn, :show, working_time: working_time)
  end

  def update(conn, %{"id" => id, "working_time" => working_time_params}) do
    working_time = Time.get_working_time!(id)

    with {:ok, %WorkingTime{} = working_time} <- Time.update_working_time(working_time, working_time_params) do
      render(conn, :show, working_time: working_time)
    end
  end

  def delete(conn, %{"id" => id}) do
    working_time = Time.get_working_time!(id)

    with {:ok, %WorkingTime{}} <- Time.delete_working_time(working_time) do
      send_resp(conn, :no_content, "")
    end
  end
end
