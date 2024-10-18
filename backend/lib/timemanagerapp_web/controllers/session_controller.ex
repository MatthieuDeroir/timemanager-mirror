defmodule TimeManagerAppWeb.SessionController do
  use TimeManagerAppWeb, :controller

  alias TimeManagerApp.Users
  alias TimeManagerApp.Auth.JWT

  @doc """
  Create a new session for a user.
  """

  def create(conn, %{"email" => email, "password" => password}) do
    case Users.authenticate_user(email, password) do
      {:ok, user} ->
        {:ok, token, claims} = JWT.generate_token(user.id, user.role_id)
        csrf_token = claims["csrf_token"]

        conn = put_resp_cookie(conn, "jwt", token, http_only: false, secure: false)

        conn
        |> put_status(:ok)
        |> json(%{csrf_token: csrf_token, user: user})

      {:error, reason} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: reason})
    end
  end

  @doc """
  Delete a session for a user.
  """
  # Implement logout functionality if needed
end
