defmodule TimeManagerAppWeb.Plugs.AuthPlug do
  import Plug.Conn
  alias TimeManagerApp.Auth.JWT
  alias TimeManagerApp.Users

  def init(default), do: default

  def call(conn, _opts) do
    conn = fetch_cookies(conn)
    IO.inspect(conn.req_cookies["jwt"])

    case conn.req_cookies["jwt"] do
      nil ->
        conn
        |> send_resp(:unauthorized, "Missing authentication token")
        |> halt()

      token ->
        case JWT.verify_token(token) do
          {:ok, claims} ->
            csrf_token_jwt = claims["csrf_token"]
            csrf_token_header = get_req_header(conn, "x-csrf-token") |> List.first()

            if csrf_token_header && csrf_token_header == csrf_token_jwt do
              # Fetch the full user from the database
              user_id = claims["user_id"]

              case Users.get_user(user_id) do
                nil ->
                  conn
                  |> send_resp(:unauthorized, "User not found")
                  |> halt()

                user ->
                  assign(conn, :current_user, user)
              end
            else
              conn
              |> send_resp(:unauthorized, "Invalid CSRF token")
              |> halt()
            end

          {:error, _reason} ->
            conn
            |> send_resp(:unauthorized, "Invalid or expired token")
            |> halt()
        end
    end
  end
end
