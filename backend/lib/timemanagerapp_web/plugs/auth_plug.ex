defmodule TimeManagerAppWeb.Plugs.AuthPlug do
  @moduledoc """
  A plug to authenticate and authorize users using JWT and CSRF tokens.

  This plug verifies the presence and validity of a JWT token in the request cookies,
  and checks for CSRF token match in the request header. If the token is valid, 
  it fetches the user from the database and assigns it to the connection.

  ## Examples
  
      # In your endpoint or router
      plug TimeManagerAppWeb.Plugs.AuthPlug
  """

  import Plug.Conn
  alias TimeManagerApp.Auth.JWT
  alias TimeManagerApp.Users

  @doc """
  Initializes the plug with the given options.

  ## Parameters

    - default: Default options for initialization.

  ## Returns
  
    - :ok
  """
  def init(default), do: default

  @doc """
  The main function for the plug that processes the connection.

  ## Parameters

    - conn: The Plug connection.
    - _opts: Options for the plug.

  ## Returns
  
    - A connection with the user assigned if authentication succeeds,
      or with an error response if it fails.
  """
  def call(conn, _opts) do
    conn = fetch_cookies(conn)

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