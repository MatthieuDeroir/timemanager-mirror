defmodule TimeManagerAppWeb.LogController do
  use TimeManagerAppWeb, :controller

  alias TimeManagerApp.Logs
  alias TimeManagerApp.Logs.Log

  action_fallback(TimeManagerAppWeb.FallbackController)

  def index(conn, _params) do
    logs = Logs.list_logs() |> TimeManagerApp.Repo.preload([user: [:role, :teams]])
    conn
    |> put_view(TimeManagerAppWeb.LogJSON)
    |> render("index.json", logs: logs)
  end

  def index_by_user(conn, %{"user_id" => user_id, "page" => page, "page_size" => page_size}) do
    page = String.to_integer(page || "1")
    page_size = String.to_integer(page_size || "50")

    logs = Logs.list_logs_by_user(user_id, page, page_size)

    conn
    |> put_view(TimeManagerAppWeb.LogJSON)
    |> render("index.json", logs: logs)
  end

  def show(conn, %{"id" => id}) do
    log = Logs.get_log!(id) |> TimeManagerApp.Repo.preload([user: [:role, :teams]])
    conn
    |> put_view(TimeManagerAppWeb.LogJSON)
    |> render("show.json", log: log)
  end

  def create(conn, %{"log" => log_params}) do
    with {:ok, %Log{} = log} <- Logs.create_log(log_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/logs/#{log}")
      |> put_view(TimeManagerAppWeb.LogJSON)
      |> render("show.json", log: TimeManagerApp.Repo.preload(log, [user: [:role, :teams]]))
    end
  end

  def delete(conn, %{"id" => id}) do
    log = Logs.get_log!(id)

    with {:ok, %Log{}} <- Logs.delete_log(log) do
      send_resp(conn, :no_content, "")
    end
  end
end
