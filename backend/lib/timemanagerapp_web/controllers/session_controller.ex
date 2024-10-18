defmodule TimeManagerAppWeb.SessionController do
  use TimeManagerAppWeb, :controller

  alias TimeManagerApp.Users

  @doc """
    Create a new session for a user.
  """

  def create(conn, %{"email" => email, "password" => password}) do
    case Users.authenticate_user(email, password) do
      {:ok, user} ->
        IO.inspect(user)

        case TimeManagerApp.Auth.JWT.generate_token(user.id) do
          {:ok, token} ->
            conn
            |> put_status(:ok)
            |> json(%{token: token})

          {:error, reason} ->
            conn
            |> put_status(:internal_server_error)
            |> json(%{error: reason})
        end

      {:error, reason} ->
        conn
        |> put_status(:unauthorized)
        |> json(%{error: reason})
    end
  end

  @doc """
  Delete a session for a user.
  """
end
