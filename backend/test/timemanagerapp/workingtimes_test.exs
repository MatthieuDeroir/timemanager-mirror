defmodule TimeManagerApp.WorkingTimesTest do
  use TimeManagerApp.DataCase

  alias TimeManagerApp.WorkingTimes
  alias TimeManagerApp.WorkingTimes.WorkingTime
  alias TimeManagerApp.Users

  describe "WorkingTimes Context" do
    setup do
      # Create a role for the user
      {:ok, role} =
        %TimeManagerApp.Roles.Role{}
        |> TimeManagerApp.Roles.Role.changeset(%{name: "employee"})
        |> Repo.insert()

      # Create a team
      {:ok, team} = TimeManagerApp.Teams.create_team(%{name: "Engineering"})

      # Create a user associated with the role and team
      {:ok, user} =
        Users.create_user(%{
          firstname: "Alice",
          lastname: "Smith",
          address: "456 Oak Street",
          phone: "555-5678",
          birthdate: ~D[1985-05-15],
          gender: "Female",
          salary: 75000.0,
          position: "Senior Developer",
          start_date: ~D[2018-06-01],
          end_date: nil,
          username: "alicesmith",
          email: "alice.smith@example.com",
          password: "securepassword",
          role_id: role.id,
          team_ids: [team.id]
        })

      {:ok, user: user, team: team}
    end

    test "create_workingtime_for_user/2 creates a working time for a user", %{user: user} do
      attrs = %{
        "start" => ~U[2024-10-22 08:00:00Z],
        "end" => ~U[2024-10-22 17:00:00Z]
      }

      assert {:ok, %WorkingTime{} = working_time} =
               WorkingTimes.create_workingtime_for_user(user.id, attrs)

      assert working_time.start == ~U[2024-10-22 08:00:00Z]
      assert working_time.end == ~U[2024-10-22 17:00:00Z]
      assert working_time.user_id == user.id
    end

    test "create_workingtime_for_user/2 fails if start time is after end time", %{user: user} do
      attrs = %{
        "start" => ~U[2024-10-22 18:00:00Z],
        "end" => ~U[2024-10-22 08:00:00Z]
      }

      assert {:error, changeset} = WorkingTimes.create_workingtime_for_user(user.id, attrs)
      assert %{end: ["must be after start time and different"]} = errors_on(changeset)
    end

    test "get_workingtime/2 retrieves a working time by ID", %{user: user} do
      attrs = %{
        "start" => ~U[2024-10-22 08:00:00Z],
        "end" => ~U[2024-10-22 17:00:00Z]
      }

      {:ok, working_time} = WorkingTimes.create_workingtime_for_user(user.id, attrs)
      assert WorkingTimes.get_workingtime(user.id, working_time.id) == working_time
    end

    test "get_workingtime/2 returns nil if the working time does not belong to the user", %{
      user: user,
      team: team
    } do
      # Create another user
      {:ok, other_user} =
        Users.create_user(%{
          firstname: "Bob",
          lastname: "Johnson",
          address: "789 Pine Street",
          phone: "555-9012",
          birthdate: ~D[1992-08-20],
          gender: "Male",
          salary: 65000.0,
          position: "Developer",
          start_date: ~D[2019-09-15],
          end_date: nil,
          username: "bobjohnson",
          email: "bob.johnson@example.com",
          password: "anotherpassword",
          role_id: user.role_id,
          team_ids: [team.id]
        })

      attrs = %{
        "start" => ~U[2024-10-22 08:00:00Z],
        "end" => ~U[2024-10-22 17:00:00Z]
      }

      {:ok, working_time} = WorkingTimes.create_workingtime_for_user(other_user.id, attrs)
      assert WorkingTimes.get_workingtime(user.id, working_time.id) == nil
    end

    test "list_workingtime_for_user/1 retrieves all working times for a user", %{user: user} do
      {:ok, _} =
        WorkingTimes.create_workingtime_for_user(user.id, %{
          "start" => ~U[2024-10-22 08:00:00Z],
          "end" => ~U[2024-10-22 17:00:00Z]
        })

      {:ok, _} =
        WorkingTimes.create_workingtime_for_user(user.id, %{
          "start" => ~U[2024-10-23 08:00:00Z],
          "end" => ~U[2024-10-23 17:00:00Z]
        })

      working_times = WorkingTimes.list_workingtime_for_user(user.id)
      assert length(working_times) == 2
    end

    test "list_workingtime_for_user/3 retrieves working times within a date range", %{user: user} do
      {:ok, _} =
        WorkingTimes.create_workingtime_for_user(user.id, %{
          "start" => ~U[2024-10-22 08:00:00Z],
          "end" => ~U[2024-10-22 17:00:00Z]
        })

      {:ok, _} =
        WorkingTimes.create_workingtime_for_user(user.id, %{
          "start" => ~U[2024-10-23 08:00:00Z],
          "end" => ~U[2024-10-23 17:00:00Z]
        })

      # Only fetch working times on 2024-10-22
      working_times =
        WorkingTimes.list_workingtime_for_user(
          user.id,
          ~U[2024-10-22 00:00:00Z],
          ~U[2024-10-22 23:59:59Z]
        )

      assert length(working_times) == 1
    end

    test "update_workingtime/2 updates a working time", %{user: user} do
      {:ok, working_time} =
        WorkingTimes.create_workingtime_for_user(user.id, %{
          "start" => ~U[2024-10-22 08:00:00Z],
          "end" => ~U[2024-10-22 17:00:00Z]
        })

      update_attrs = %{"end" => ~U[2024-10-22 18:00:00Z]}

      assert {:ok, updated_working_time} =
               WorkingTimes.update_workingtime(working_time, update_attrs)

      assert updated_working_time.end == ~U[2024-10-22 18:00:00Z]
    end

    test "delete_workingtime/1 deletes a working time", %{user: user} do
      {:ok, working_time} =
        WorkingTimes.create_workingtime_for_user(user.id, %{
          "start" => ~U[2024-10-22 08:00:00Z],
          "end" => ~U[2024-10-22 17:00:00Z]
        })

      assert {:ok, _} = WorkingTimes.delete_workingtime(working_time)
      assert WorkingTimes.get_workingtime(user.id, working_time.id) == nil
    end
  end
end
