# test/timemanagerapp/teams_test.exs
defmodule TimeManagerApp.TeamsTest do
  use TimeManagerApp.DataCase

  alias TimeManagerApp.Teams
  alias TimeManagerApp.Teams.Team

  import TimeManagerApp.TeamsFixtures

  # @valid_attrs %{name: "Engineering"}
  # @update_attrs %{name: "Marketing"}
  @invalid_attrs %{name: nil}

  describe "teams" do
    test "list_teams/0 returns all teams" do
      team = team_fixture()
      assert Teams.list_teams() == [team]
    end

    test "get_team!/1 returns the team with given id" do
      team = team_fixture()
      assert Teams.get_team!(team.id) == team
    end

    test "create_team/1 with valid data creates a team" do
      user = user_fixture()
      valid_attrs = %{name: "Engineering", user_ids: [user.id]}

      assert {:ok, %Team{} = team} = Teams.create_team(valid_attrs)
      assert team.name == "Engineering"

      # Fetch the team with preloaded users to ensure consistency
      fetched_team = Teams.get_team!(team.id)
      assert length(fetched_team.users) == 1
      assert Enum.any?(fetched_team.users, fn u -> u.id == user.id end)
    end

    test "create_team/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Teams.create_team(@invalid_attrs)
    end

    test "update_team/2 with valid data updates the team" do
      team = team_fixture()
      user = user_fixture()
      update_attrs = %{name: "Marketing", user_ids: [user.id]}

      assert {:ok, %Team{} = team} = Teams.update_team(team, update_attrs)
      assert team.name == "Marketing"

      # Fetch the team with preloaded users to ensure consistency
      fetched_team = Teams.get_team!(team.id)
      assert length(fetched_team.users) == 1
      assert Enum.any?(fetched_team.users, fn u -> u.id == user.id end)
    end

    test "update_team/2 with invalid data returns error changeset" do
      team = team_fixture()
      assert {:error, %Ecto.Changeset{}} = Teams.update_team(team, @invalid_attrs)
      assert team == Teams.get_team!(team.id)
    end

    test "delete_team/1 deletes the team" do
      team = team_fixture()
      assert {:ok, %Team{}} = Teams.delete_team(team)
      assert_raise Ecto.NoResultsError, fn -> Teams.get_team!(team.id) end
    end

    test "list_teams_by_user_id/1 returns teams the user belongs to" do
      team = team_fixture()
      user = user_fixture()
      {:ok, _team} = Teams.add_user_to_team(team.id, user.id)

      teams = Teams.list_teams_by_user_id(user.id)
      assert length(teams) == 1

      fetched_team = hd(teams)
      assert fetched_team.id == team.id
      assert fetched_team.name == "Engineering"

      assert length(fetched_team.users) == 1
      fetched_user = hd(fetched_team.users)
      assert fetched_user.id == user.id
      assert fetched_user.email == "john.doe@example.com"
      # Add more field-specific assertions as needed
    end

    test "get_teams_by_ids/1 returns teams matching the given ids" do
      team1 = team_fixture(%{name: "Engineering"})
      team2 = team_fixture(%{name: "Marketing"})
      team3 = team_fixture(%{name: "HR"})

      assert Teams.get_teams_by_ids([team1.id, team2.id]) == [team1, team2]
      assert Teams.get_teams_by_ids([team3.id]) == [team3]
      assert Teams.get_teams_by_ids([999]) == []
    end

    test "add_user_to_team/2 adds a user to the team" do
      team = team_fixture()
      user = user_fixture()

      assert {:ok, %Team{} = team} = Teams.add_user_to_team(team.id, user.id)
      assert user in team.users
    end

    test "remove_user_from_team/2 removes a user from the team" do
      team = team_fixture()
      user = user_fixture()

      {:ok, team} = Teams.add_user_to_team(team.id, user.id)
      assert user in team.users

      assert {:ok, %Team{} = team} = Teams.remove_user_from_team(team.id, user.id)
      refute user in team.users
    end

    test "change_team/1 returns a team changeset" do
      team = team_fixture()
      assert %Ecto.Changeset{} = Teams.change_team(team)
    end
  end
end
