defmodule TimeManagerAppWeb.UserControllerTest do
  use TimeManagerAppWeb.ConnCase

  import TimeManagerApp.UsersFixtures

  alias TimeManagerApp.Users.User

  @create_attrs %{
    address: "some address",
    birthdate: ~D[2024-10-13],
    email: "some email",
    end_date: ~D[2024-10-13],
    firstname: "some firstname",
    gender: "some gender",
    lastname: "some lastname",
    password_hash: "some password_hash",
    phone: "some phone",
    position: "some position",
    salary: 120.5,
    start_date: ~D[2024-10-13],
    username: "some username"
  }
  @update_attrs %{
    address: "some updated address",
    birthdate: ~D[2024-10-14],
    email: "some updated email",
    end_date: ~D[2024-10-14],
    firstname: "some updated firstname",
    gender: "some updated gender",
    lastname: "some updated lastname",
    password_hash: "some updated password_hash",
    phone: "some updated phone",
    position: "some updated position",
    salary: 456.7,
    start_date: ~D[2024-10-14],
    username: "some updated username"
  }
  @invalid_attrs %{address: nil, birthdate: nil, email: nil, end_date: nil, firstname: nil, gender: nil, lastname: nil, password_hash: nil, phone: nil, position: nil, salary: nil, start_date: nil, username: nil}

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
               "address" => "some address",
               "birthdate" => "2024-10-13",
               "email" => "some email",
               "end_date" => "2024-10-13",
               "firstname" => "some firstname",
               "gender" => "some gender",
               "lastname" => "some lastname",
               "password_hash" => "some password_hash",
               "phone" => "some phone",
               "position" => "some position",
               "salary" => 120.5,
               "start_date" => "2024-10-13",
               "username" => "some username"
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
               "address" => "some updated address",
               "birthdate" => "2024-10-14",
               "email" => "some updated email",
               "end_date" => "2024-10-14",
               "firstname" => "some updated firstname",
               "gender" => "some updated gender",
               "lastname" => "some updated lastname",
               "password_hash" => "some updated password_hash",
               "phone" => "some updated phone",
               "position" => "some updated position",
               "salary" => 456.7,
               "start_date" => "2024-10-14",
               "username" => "some updated username"
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
