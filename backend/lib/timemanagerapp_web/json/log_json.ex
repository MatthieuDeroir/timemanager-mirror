defmodule TimeManagerAppWeb.LogJSON do

  def render("index.json", %{logs: logs}) do
    %{logs: Enum.map(logs, &format_log/1)}
  end

  def render("show.json", %{log: log}) do
    format_log(log)
  end

  defp format_log(%TimeManagerApp.Logs.Log{
    action: action,
    message: message,
    user: %TimeManagerApp.Users.User{
      id: user_id,
      username: username,
      role: role,
      teams: teams
    }
  }) do
    %{
      action: action,
      message: message,
      user: %{
        id: user_id,
        username: username,
        role: %{
          id: role.id,
          name: role.name
        },
        teams: Enum.map(teams, fn team ->
          %{id: team.id, name: team.name}
        end)
      }
    }
  end

  defp format_log(%TimeManagerApp.Logs.Log{
    action: action,
    message: message,
    user: nil
  }) do
    %{
      action: action,
      message: message,
      user: nil
    }
  end
end
