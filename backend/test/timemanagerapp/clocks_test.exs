defmodule TimeManagerApp.ClocksTest do
  use TimeManagerApp.DataCase

  alias TimeManagerApp.Clocks
  alias TimeManagerApp.Clocks.Clock
  alias TimeManagerApp.Users

  describe "Clocks Context" do
    @valid_attrs %{
      time: ~U[2024-04-21 10:00:00Z],
      status: true
    }

    @invalid_attrs %{
      time: nil,
      status: nil
    }

    setup do
      {:ok, role} =
        %TimeManagerApp.Roles.Role{}
        |> TimeManagerApp.Roles.Role.changeset(%{name: "employee"})
        |> Repo.insert()

      {:ok, team} = TimeManagerApp.Teams.create_team(%{name: "Engineering"})

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

    test "list_clocks_for_user/1 returns all clocks for the given user", %{user: user} do
      {:ok, clock1} =
        Clocks.create_clock_for_user(user.id, Map.put(@valid_attrs, :user_id, user.id))

      {:ok, clock2} =
        Clocks.create_clock_for_user(user.id, %{time: ~U[2024-04-21 18:00:00Z], status: false})

      clocks = Clocks.list_clocks_for_user(user.id)
      assert length(clocks) == 2
      assert Enum.any?(clocks, fn c -> c.id == clock1.id end)
      assert Enum.any?(clocks, fn c -> c.id == clock2.id end)
    end

    test "get_clock/2 returns the clock with given id for the user", %{user: user} do
      {:ok, clock} =
        Clocks.create_clock_for_user(user.id, Map.put(@valid_attrs, :user_id, user.id))

      fetched_clock = Clocks.get_clock(user.id, clock.id)
      assert fetched_clock.id == clock.id
      assert fetched_clock.user_id == user.id
    end

    test "get_clock/2 returns nil if the clock does not exist or does not belong to the user", %{
      user: user,
      team: team
    } do
      assert Clocks.get_clock(user.id, 999) == nil

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

      {:ok, clock} =
        Clocks.create_clock_for_user(
          other_user.id,
          Map.put(@valid_attrs, :user_id, other_user.id)
        )

      assert Clocks.get_clock(user.id, clock.id) == nil
    end

    test "create_clock_for_user/2 with valid data creates a clock", %{user: user} do
      attrs = Map.put(@valid_attrs, :user_id, user.id)

      assert {:ok, %Clock{} = clock} = Clocks.create_clock_for_user(user.id, attrs)
      assert clock.time == ~U[2024-04-21 10:00:00Z]
      assert clock.status == true
      assert clock.user_id == user.id
    end

    test "create_clock_for_user/2 with invalid data returns error changeset", %{user: user} do
      assert {:error, %Ecto.Changeset{} = changeset} =
               Clocks.create_clock_for_user(user.id, @invalid_attrs)

      assert %{
               time: ["can't be blank"],
               status: ["can't be blank"]
             } = errors_on(changeset)
    end

    test "create_clock_for_user/2 fails if user does not exist" do
      invalid_user_id = -1
      attrs = Map.put(@valid_attrs, :user_id, invalid_user_id)

      assert {:error, %Ecto.Changeset{} = changeset} =
               Clocks.create_clock_for_user(invalid_user_id, attrs)

      assert %{user_id: ["does not exist"]} = errors_on(changeset)
    end
  end
end
