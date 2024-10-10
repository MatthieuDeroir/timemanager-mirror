defmodule TimeManagerAppWeb.ClockController do
  use TimeManagerAppWeb, :controller
  use PhoenixSwagger

  alias TimeManagerApp.Time
  alias TimeManagerApp.Time.Clock
  alias TimeManagerAppWeb.FallbackController
  alias TimeManagerAppWeb.Swagger.ClockSwagger

  action_fallback(FallbackController)

  Module.eval_quoted(__MODULE__, ClockSwagger.paths())

  # GET /clocks/:user_id
  def index(conn, %{"user_id" => user_id}) do
    clocks = Time.list_clocks_for_user(user_id)
    json(conn, clocks)
  end

  # POST /clocks/:user_id
  def create(conn, %{"user_id" => user_id, "clocks" => clock_params}) do
    case Time.create_clock_for_user(user_id, clock_params) do
      {:ok, clock} ->
        conn
        |> put_status(:created)
        |> json(%{clock: clock})

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: changeset})
    end
  end

  def show(conn, %{"user_id" => user_id, "id" => id}) do
    case Time.get_clock(user_id, id) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{error: "Clock not found"})

      clock ->
        json(conn, %{clock: clock})
    end
  end

  # Swagger schema pour Clock
  def swagger_definitions do
    ClockSwagger.swagger_definitions()
  end
end
