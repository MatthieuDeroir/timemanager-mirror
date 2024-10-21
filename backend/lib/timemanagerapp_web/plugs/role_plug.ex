defmodule TimeManagerAppWeb.Plugs.AuthorizeRole do
  import Plug.Conn
  alias TimeManagerApp.Auth.JWT

  # Define role hierarchy (lower number = higher privilege)
  @role_hierarchy %{
    "admin" => 1,
    "generalmanager" => 2,
    "manager" => 3,
    "employee" => 4
  }

  def init(default), do: default

  def call(conn, min_role_id) when is_integer(min_role_id) do
    with {:ok, token} <- fetch_jwt(conn),
         {:ok, claims} <- JWT.verify_and_validate(token),
         {:ok, user_role_id} <- fetch_role_id(claims),
         true <- user_role_id <= min_role_id do
      assign(conn, :current_user, %{id: claims["sub"], role_id: user_role_id})
    else
      {:error, :no_token} ->
        conn
        |> send_resp(:unauthorized, "Missing authentication token")
        |> halt()

      {:error, :invalid_token} ->
        conn
        |> send_resp(:unauthorized, "Invalid authentication token")
        |> halt()

      {:error, :missing_role_id} ->
        conn
        |> send_resp(:unauthorized, "Missing role information")
        |> halt()

      false ->
        conn
        |> send_resp(:forbidden, "Access denied")
        |> halt()
    end
  end

  # Allow passing multiple role IDs for flexibility
  def call(conn, required_role_ids) when is_list(required_role_ids) do
    with {:ok, token} <- fetch_jwt(conn),
         {:ok, claims} <- JWT.verify_and_validate(token),
         {:ok, user_role_id} <- fetch_role_id(claims),
         true <- user_role_id in required_role_ids do
      assign(conn, :current_user, %{id: claims["sub"], role_id: user_role_id})
    else
      {:error, :no_token} ->
        conn
        |> send_resp(:unauthorized, "Missing authentication token")
        |> halt()

      {:error, :invalid_token} ->
        conn
        |> send_resp(:unauthorized, "Invalid authentication token")
        |> halt()

      {:error, :missing_role_id} ->
        conn
        |> send_resp(:unauthorized, "Missing role information")
        |> halt()

      false ->
        conn
        |> send_resp(:forbidden, "Access denied")
        |> halt()
    end
  end

  defp fetch_jwt(conn) do
    conn = fetch_cookies(conn)

    case conn.req_cookies["jwt"] do
      nil -> {:error, :no_token}
      token -> {:ok, token}
    end
  end

  defp fetch_role_id(claims) do
    case claims["role_id"] do
      nil ->
        {:error, :missing_role_id}

      role_id when is_integer(role_id) ->
        {:ok, role_id}

      role_id when is_binary(role_id) ->
        case Integer.parse(role_id) do
          {parsed_role_id, _} -> {:ok, parsed_role_id}
          :error -> {:error, :invalid_role_id}
        end
    end
  end
end
