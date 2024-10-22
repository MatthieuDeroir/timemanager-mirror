defmodule TimeManagerAppWeb.ClockController do
  use TimeManagerAppWeb, :controller
  use PhoenixSwagger

  alias TimeManagerApp.Clocks
  alias TimeManagerAppWeb.FallbackController
  alias TimeManagerAppWeb.Swagger.ClockSwagger

  action_fallback(FallbackController)

  Module.eval_quoted(__MODULE__, ClockSwagger.paths())

  # GET /clocks/:user_id
  def index(conn, %{"user_id" => user_id}) do
    clocks = Clocks.list_clocks_for_user(user_id)
    json(conn, clocks)
  end

  # POST /clocks/:user_id
  def create(conn, %{"user_id" => user_id, "clocks" => clock_params}) do
    # Normalize the keys in clock_params to ensure consistency
    normalized_params = normalize_keys(clock_params)

    case Clocks.create_clock_for_user(user_id, normalized_params) do
      {:ok, clock} ->
        conn
        |> put_status(:created)
        |> json(clock)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: changeset})
    end
  end

  # Utility function to convert all keys to strings
  defp normalize_keys(params) do
    params
    |> Enum.into(%{}, fn
      {key, value} when is_atom(key) -> {Atom.to_string(key), value}
      {key, value} -> {key, value}
    end)
  end

  def show(conn, %{"user_id" => user_id, "id" => id}) do
    case Clocks.get_clock(user_id, id) do
      nil ->
        json(conn, [])

      clock ->
        json(conn, %{clock: clock})
    end
  end

  # Swagger schema pour Clock
  def swagger_definitions do
    ClockSwagger.swagger_definitions()
  end
end
