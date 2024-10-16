defmodule TimeManagerApp.AccountsTest do
  use TimeManagerApp.DataCase

  alias TimeManagerApp.Accounts

  describe "users" do
    alias TimeManagerApp.Accounts.User

    import TimeManagerApp.AccountsFixtures

    @invalid_attrs %{created_at: nil, first_name: nil, inserted_at: nil, last_name: nil}

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{created_at: ~U[2024-10-06 13:58:00Z], first_name: "some first_name", inserted_at: ~U[2024-10-06 13:58:00Z], last_name: "some last_name"}

      assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
      assert user.created_at == ~U[2024-10-06 13:58:00Z]
      assert user.first_name == "some first_name"
      assert user.inserted_at == ~U[2024-10-06 13:58:00Z]
      assert user.last_name == "some last_name"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      update_attrs = %{created_at: ~U[2024-10-07 13:58:00Z], first_name: "some updated first_name", inserted_at: ~U[2024-10-07 13:58:00Z], last_name: "some updated last_name"}

      assert {:ok, %User{} = user} = Accounts.update_user(user, update_attrs)
      assert user.created_at == ~U[2024-10-07 13:58:00Z]
      assert user.first_name == "some updated first_name"
      assert user.inserted_at == ~U[2024-10-07 13:58:00Z]
      assert user.last_name == "some updated last_name"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end
end
