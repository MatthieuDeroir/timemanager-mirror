defmodule TimeManagerAppWeb.TeamJSON do
  alias TimeManagerApp.Teams.Team
  alias TimeManagerAppWeb.UserJSON

  @doc """
  Renders a list of teams.
  """
  def render("index.json", %{teams: teams}) do
    %{data: Enum.map(teams, &team_data/1)}
  end

  @doc """
  Renders a single team.
  """
  def render("show.json", %{team: team}) do
    %{data: team_data(team)}
  end

  defp team_data(%Team{} = team) do
    %{
      id: team.id,
      name: team.name,
      users: Enum.map(team.users, &UserJSON.user_data/1),
      inserted_at: team.inserted_at,
      updated_at: team.updated_at
    }
  end
end
