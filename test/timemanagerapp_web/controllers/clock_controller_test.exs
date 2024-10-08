defmodule TimeManagerAppWeb.ClockControllerTest do
  use TimeManagerAppWeb.ConnCase

  import TimeManagerApp.TimeFixtures

  @valid_clock_attrs %{status: true, time: ~U[2024-10-06 14:20:00Z]}
  @invalid_clock_attrs %{status: nil, time: nil}

  describe "create clock" do
    test "renders clock when data is valid", %{conn: conn} do
      # Create a mock user
      user = user_fixture()
      conn = post(conn, ~p"/api/clocks/#{user.id}", clock: @valid_clock_attrs)

      assert %{"id" => id} = json_response(conn, 201)["data"]
      conn = get(conn, ~p"/api/clocks/#{user.id}/#{id}")

      assert %{
               "id" => id,
               "status" => true,
               "time" => "2024-10-06T14:20:00Z"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      # Create a mock user
      user = user_fixture()
      conn = post(conn, ~p"/api/clocks/#{user.id}", clock: @invalid_clock_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end
end
