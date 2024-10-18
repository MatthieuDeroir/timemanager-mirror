defmodule TimeManagerAppWeb.Plugs.AuthPlug do
  import Plug.Conn
  alias TimeManagerApp.Auth.JWT

  def init(opts), do: opts

  def call(conn, _opts) do
    case get_req_header(conn, "authorization") do
      ["Bearer " <> token] ->
        case JWT.verify_token(token) do
          {:ok, claims} ->
            assign(conn, :current_user, claims["user_id"])

          {:error, _reason} ->
            conn
            |> send_resp(:unauthorized, "Invalid or expired token")
            |> halt()
        end

      _ ->
        conn
        |> send_resp(:unauthorized, "Missing authorization header")
        |> halt()
    end
  end
end
