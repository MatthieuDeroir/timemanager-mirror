defmodule TimeManagerAppWeb.ClockController do
  use TimeManagerAppWeb, :controller
  use PhoenixSwagger

  alias TimeManagerApp.Clocks
  alias TimeManagerAppWeb.FallbackController
  alias TimeManagerAppWeb.Swagger.ClockSwagger

  # Sets up fallback controller for action errors
  action_fallback(FallbackController)

  # Defines the Swagger paths dynamically for the module
  Module.eval_quoted(__MODULE__, ClockSwagger.paths())

  @doc """
  Lists all clocks for a specified user.

  ## Parameters
  - conn: The connection object.
  - user_id: The user ID for whom clocks are being fetched.

  ## Responses
  - 200: A JSON response containing the clocks for the user.
  """
  # GET /clocks/:user_id
  def index(conn, %{"user_id" => user_id}) do
    clocks = Clocks.list_clocks_for_user(user_id)
    json(conn, clocks)
  end

  @doc """
  Creates a new clock entry for a specified user.

  ## Parameters
  - conn: The connection object.
  - user_id: The user ID for whom the clock is being created.
  - clock_params: The parameters of the clock to be created.

  ## Responses
  - 201: A JSON response containing the created clock.
  - 422: A JSON response containing validation errors.
  """
  # POST /clocks/:user_id
  def create(conn, %{"user_id" => user_id, "clocks" => clock_params}) do
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

  @doc """
  Utility function to convert all keys to strings.

  ## Parameters
  - params: The parameters map where keys need to be normalized.

  ## Returns
  A map with all keys converted to strings.
  """
  # Utility function to convert all keys to strings
  defp normalize_keys(params) do
    params
    |> Enum.into(%{}, fn
      {key, value} when is_atom(key) -> {Atom.to_string(key), value}
      {key, value} -> {key, value}
    end)
  end

  @doc """
  Shows details of a specific clock for a specified user.

  ## Parameters
  - conn: The connection object.
  - user_id: The user ID for whom the clock is being fetched.
  - id: The ID of the clock to be fetched.

  ## Responses
  - 200: A JSON response containing the clock details.
  - 404: A JSON response with an empty list if clock is not found.
  """
  def show(conn, %{"user_id" => user_id, "id" => id}) do
    case Clocks.get_clock(user_id, id) do
      nil ->
        json(conn, [])

      clock ->
        json(conn, %{clock: clock})
    end
  end

  @doc """
  Provides Swagger schema definitions for Clock.

  ## Returns
  A map containing Swagger schema definitions for Clock.
  """
  def swagger_definitions do
    ClockSwagger.swagger_definitions()
  end
end