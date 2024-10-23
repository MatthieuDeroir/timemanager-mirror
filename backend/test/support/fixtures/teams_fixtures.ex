# test/support/fixtures/teams_fixtures.ex
defmodule TimeManagerApp.TeamsFixtures do
  alias TimeManagerApp.Repo
  alias TimeManagerApp.Users

  def team_fixture(attrs \\ %{}) do
    {:ok, team} =
      attrs
      |> Enum.into(%{name: "Engineering"})
      |> TimeManagerApp.Teams.create_team()

    Repo.preload(team, :users)
  end

  def user_fixture(attrs \\ %{}) do
    # Ensure a role is provided or create a default one
    role =
      case attrs[:role] do
        nil ->
          {:ok, role} =
            %TimeManagerApp.Roles.Role{}
            |> TimeManagerApp.Roles.Role.changeset(%{name: "employee"})
            |> Repo.insert()

          role

        %TimeManagerApp.Roles.Role{} = role ->
          role

        role_id when is_integer(role_id) ->
          Repo.get!(TimeManagerApp.Roles.Role, role_id)

        _ ->
          raise ArgumentError, "Invalid role provided to user_fixture/1"
      end

    user_attrs =
      attrs
      |> Enum.into(%{
        firstname: "John",
        lastname: "Doe",
        email: "john.doe@example.com",
        username: "johndoe",
        password: "password123",
        role_id: role.id
      })

    {:ok, user} = Users.create_user(user_attrs)
    Repo.preload(user, :teams)
  end
end
