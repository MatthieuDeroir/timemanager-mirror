defmodule TimeManagerAppWeb.UserControllerTest do
  use TimeManagerAppWeb.ConnCase

  import TimeManagerApp.AccountsFixtures

  alias TimeManagerApp.Accounts.User

  @create_attrs %{
    created_at: ~U[2024-10-06 13:58:00Z],
    first_name: "some first_name",
    inserted_at: ~U[2024-10-06 13:58:00Z],
    last_name: "some last_name"
  }
  @update_attrs %{
    created_at: ~U[2024-10-07 13:58:00Z],
    first_name: "some updated first_name",
    inserted_at: ~U[2024-10-07 13:58:00Z],
    last_name: "some updated last_name"
  }
  @invalid_attrs %{created_at: nil, first_name: nil, inserted_at: nil, last_name: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get(conn, ~p"/api/users")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/users/#{id}")

      assert %{
               "id" => ^id,
               "created_at" => "2024-10-06T13:58:00Z",
               "first_name" => "some first_name",
               "inserted_at" => "2024-10-06T13:58:00Z",
               "last_name" => "some last_name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put(conn, ~p"/api/users/#{user}", user: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/users/#{id}")

      assert %{
               "id" => ^id,
               "created_at" => "2024-10-07T13:58:00Z",
               "first_name" => "some updated first_name",
               "inserted_at" => "2024-10-07T13:58:00Z",
               "last_name" => "some updated last_name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, ~p"/api/users/#{user}", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, ~p"/api/users/#{user}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/users/#{user}")
      end
    end
  end

  defp create_user(_) do
    user = user_fixture()
    %{user: user}
  end
end
