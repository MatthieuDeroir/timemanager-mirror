# test/timemanagerapp/users_test.exs
defmodule TimeManagerApp.UsersTest do
  use TimeManagerApp.DataCase

  alias TimeManagerApp.Users
  alias TimeManagerApp.Users.User
  alias TimeManagerApp.Teams

  describe "Users Context" do
    @valid_attrs %{
      firstname: "John",
      lastname: "Doe",
      address: "123 Elm Street",
      phone: "555-1234",
      birthdate: ~D[1990-01-01],
      gender: "Male",
      salary: 60000.0,
      position: "Developer",
      start_date: ~D[2020-01-01],
      end_date: nil,
      username: "johndoe",
      email: "john.doe@example.com",
      password: "password123",
      role_id: 1
    }

    @invalid_attrs %{
      firstname: nil,
      lastname: nil,
      # Added username
      username: nil,
      email: "invalidemail",
      password: "short",
      salary: -1000.0
    }

    setup do
      # Create a role for the user
      {:ok, role} =
        %TimeManagerApp.Roles.Role{}
        |> TimeManagerApp.Roles.Role.changeset(%{name: "employee"})
        |> Repo.insert()

      # Create a team
      {:ok, team} = Teams.create_team(%{name: "Engineering"})

      {:ok, role: role, team: team}
    end

    test "list_users/0 returns all users", %{role: role, team: team} do
      {:ok, user} =
        Users.create_user(
          Map.put(@valid_attrs, :role_id, role.id)
          |> Map.put(:team_ids, [team.id])
        )

      users = Users.list_users()
      assert length(users) == 1
      assert Enum.any?(users, fn u -> u.id == user.id end)
    end

    test "get_user/1 returns the user with given id", %{role: role, team: team} do
      {:ok, user} =
        Users.create_user(
          Map.put(@valid_attrs, :role_id, role.id)
          |> Map.put(:team_ids, [team.id])
        )

      fetched_user = Users.get_user(user.id)
      assert fetched_user.id == user.id
      assert fetched_user.teams |> hd |> Map.get(:id) == team.id
    end

    test "create_user/1 with valid data creates a user", %{role: role, team: team} do
      attrs = Map.put(@valid_attrs, :role_id, role.id) |> Map.put(:team_ids, [team.id])

      assert {:ok, %User{} = user} = Users.create_user(attrs)
      assert user.firstname == "John"
      assert user.email == "john.doe@example.com"
      assert user.password_hash != nil
      assert user.teams |> hd |> Map.get(:id) == team.id
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{} = changeset} = Users.create_user(@invalid_attrs)

      assert %{
               email: ["is not a valid email"],
               password: ["Password must be at least 6 characters long"],
               salary: ["Salary cannot be negative"],
               firstname: ["can't be blank"],
               lastname: ["can't be blank"]
             } = errors_on(changeset)
    end

    test "create_user/1 enforces unique email", %{role: role, team: team} do
      attrs = Map.put(@valid_attrs, :role_id, role.id) |> Map.put(:team_ids, [team.id])
      {:ok, _user} = Users.create_user(attrs)
      assert {:error, changeset} = Users.create_user(attrs)
      assert %{email: ["has already been taken"]} = errors_on(changeset)
    end

    test "update_user/2 with valid data updates the user", %{role: role, team: team} do
      {:ok, user} =
        Users.create_user(
          Map.put(@valid_attrs, :role_id, role.id)
          |> Map.put(:team_ids, [team.id])
        )

      update_attrs = %{firstname: "Jane", salary: 65000.0}

      assert {:ok, %User{} = updated_user} = Users.update_user(user, update_attrs)
      assert updated_user.firstname == "Jane"
      assert updated_user.salary == 65000.0
    end

    test "update_user/2 with invalid data returns error changeset", %{role: role, team: team} do
      {:ok, user} =
        Users.create_user(
          Map.put(@valid_attrs, :role_id, role.id)
          |> Map.put(:team_ids, [team.id])
        )

      assert {:error, %Ecto.Changeset{} = changeset} = Users.update_user(user, @invalid_attrs)

      # Assert that the changeset contains the expected validation errors
      assert %{
               email: ["is not a valid email"],
               password: ["Password must be at least 6 characters long"],
               salary: ["Salary cannot be negative"]
             } = errors_on(changeset)

      # Fetch the user again to ensure no changes were persisted
      fetched_user = Users.get_user(user.id)

      # Compare individual fields to ensure they remain unchanged
      assert fetched_user.id == user.id
      assert fetched_user.firstname == user.firstname
      assert fetched_user.lastname == user.lastname
      assert fetched_user.address == user.address
      assert fetched_user.phone == user.phone
      assert fetched_user.birthdate == user.birthdate
      assert fetched_user.gender == user.gender
      assert fetched_user.salary == user.salary
      assert fetched_user.position == user.position
      assert fetched_user.start_date == user.start_date
      assert fetched_user.end_date == user.end_date
      assert fetched_user.username == user.username
      assert fetched_user.email == user.email
      assert fetched_user.role_id == user.role_id
      # Add any other relevant field comparisons as necessary
    end

    test "delete_user/1 deletes the user", %{role: role, team: team} do
      {:ok, user} =
        Users.create_user(
          Map.put(@valid_attrs, :role_id, role.id)
          |> Map.put(:team_ids, [team.id])
        )

      assert {:ok, %User{}} = Users.delete_user(user)
      assert Users.get_user(user.id) == nil
    end

    test "authenticate_user/2 returns user with correct credentials", %{role: role, team: team} do
      {:ok, user} =
        Users.create_user(
          Map.put(@valid_attrs, :role_id, role.id)
          |> Map.put(:team_ids, [team.id])
        )

      assert {:ok, auth_user} = Users.authenticate_user(user.email, "password123")
      assert auth_user.id == user.id
    end

    test "authenticate_user/2 returns error with incorrect password", %{role: role, team: team} do
      {:ok, user} =
        Users.create_user(
          Map.put(@valid_attrs, :role_id, role.id)
          |> Map.put(:team_ids, [team.id])
        )

      assert {:error, "Invalid password"} = Users.authenticate_user(user.email, "wrongpassword")
    end

    test "authenticate_user/2 returns error if user not found" do
      assert {:error, "User not found"} =
               Users.authenticate_user("nonexistent@example.com", "password123")
    end

    test "list_users_by_email_and_username/2 returns filtered users", %{role: role, team: team} do
      {:ok, user1} =
        Users.create_user(
          Map.put(@valid_attrs, :email, "alice@example.com")
          |> Map.put(:username, "alice123")
          |> Map.put(:role_id, role.id)
          |> Map.put(:team_ids, [team.id])
        )

      {:ok, user2} =
        Users.create_user(
          Map.put(@valid_attrs, :email, "bob@example.com")
          |> Map.put(:username, "bob456")
          |> Map.put(:username, "bob456")
          |> Map.put(:role_id, role.id)
          |> Map.put(:team_ids, [team.id])
        )

      users = Users.list_users_by_email_and_username("alice", "alice")
      assert length(users) == 1
      assert hd(users).id == user1.id

      users = Users.list_users_by_email_and_username("example.com", "bob")
      assert length(users) == 1
      assert hd(users).id == user2.id

      users = Users.list_users_by_email_and_username("nonexistent", "user")
      assert length(users) == 0
    end
  end
end
