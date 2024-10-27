defmodule TimeManagerApp.Logs.LogTest do
  use TimeManagerApp.DataCase, async: true

  alias TimeManagerApp.Logs
  alias TimeManagerApp.Users
  alias TimeManagerApp.Repo
  alias TimeManagerApp.Logs.Log
  alias TimeManagerApp.Users.User

  @valid_user_attrs %{username: "user1", email: "user1@example.com"}
  @valid_role_attrs %{name: "admin"}
  @valid_team_attrs %{name: "development"}
  @log_attrs %{action: "CREATE", message: "Created a new resource"}

  setup do
    role = %TimeManagerApp.Users.Role{} |> Users.create_role(@valid_role_attrs)
    team = %TimeManagerApp.Users.Team{} |> Users.create_team(@valid_team_attrs)

    user =
      %User{}
      |> User.changeset(Map.merge(@valid_user_attrs, %{role_id: role.id}))
      |> Repo.insert!()

    # Associate the user with a team
    Repo.insert!(%TimeManagerApp.Users.UserTeam{user_id: user.id, team_id: team.id})

    {:ok, %{user: user, role: role, team: team}}
  end

  describe "list_logs_by_role/1" do
    test "fetches logs filtered by role", %{user: user, role: role} do
      Logs.log_action(user.id, "TEST", "Test action")
      logs = Logs.list_logs_by_role(role.id)

      assert length(logs) == 1
      assert hd(logs).user.role_id == role.id
    end
  end

  describe "list_logs_by_team/1" do
    test "fetches logs filtered by team", %{user: user, team: team} do
      Logs.log_action(user.id, "TEST", "Test action")
      logs = Logs.list_logs_by_team(team.id)

      assert length(logs) == 1
      assert hd(logs).user.teams |> Enum.any?(fn t -> t.id == team.id end)
    end
  end

  describe "list_logs_by_user/1" do
    test "fetches logs filtered by user", %{user: user} do
      Logs.log_action(user.id, "TEST", "Test action")
      logs = Logs.list_logs_by_user(user.id)

      assert length(logs) == 1
      assert hd(logs).user_id == user.id
    end
  end

  describe "list_logs_by_date_range/2" do
    test "fetches logs within a specific date range", %{user: user} do
      Logs.log_action(user.id, "TEST", "Test action")
      start_date = DateTime.utc_now() |> DateTime.add(-3600, :second)
      end_date = DateTime.utc_now() |> DateTime.add(3600, :second)

      logs = Logs.list_logs_by_date_range(start_date, end_date)

      assert length(logs) == 1
      assert hd(logs).user_id == user.id
    end

    test "excludes logs outside of the date range", %{user: user} do
      Logs.log_action(user.id, "TEST", "Test action")
      start_date = DateTime.utc_now() |> DateTime.add(-7200, :second)
      end_date = DateTime.utc_now() |> DateTime.add(-3600, :second)

      logs = Logs.list_logs_by_date_range(start_date, end_date)

      assert length(logs) == 0
    end
  end


end
