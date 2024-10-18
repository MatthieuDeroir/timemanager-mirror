defmodule TimeManagerAppWeb.Plugs.AuthorizeRole do
  import Plug.Conn
  alias TimeManagerApp.Auth.JWT

  def init(default), do: default

  def call(conn, required_role_id) do
    with {:ok, token} <- fetch_jwt(conn),
         {:ok, claims} <- JWT.verify_and_validate(token),
         {:ok, user_role_id} <- fetch_role_id(claims),
         true <- authorized?(user_role_id, required_role_id) do
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
    case get_bearer_token(conn) do
      nil -> {:error, :no_token}
      token -> {:ok, token}
    end
  end

  defp get_bearer_token(conn) do
    with ["Bearer " <> token] <- get_req_header(conn, "authorization") do
      token
    else
      _ -> nil
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

  # Adjusted the comparison to reflect your role hierarchy
  defp authorized?(user_role_id, required_role_id)
       when is_integer(user_role_id) and is_integer(required_role_id) do
    user_role_id <= required_role_id
  end

  defp authorized?(_, _), do: false
end
