defmodule TimeManagerAppWeb.Plugs.LogPlug do
  import Plug.Conn
  alias TimeManagerApp.Logs

  def init(opts), do: opts

  def call(conn, _opts) do
    # Extract user info and action from the connection
    user = conn.assigns[:current_user]
    action = "#{conn.method} #{conn.request_path}"

    # Check if user is authenticated and extract user details
    user_id = if user, do: user.id, else: nil
    message = "Action: #{action} performed by #{user && user.username || "unknown"}"

    # Log the action to the database
    Logs.log_action(user_id, action, message)

    # Proceed with the request
    conn
  end
end
