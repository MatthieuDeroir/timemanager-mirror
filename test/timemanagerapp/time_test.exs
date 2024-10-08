defmodule TimeManagerApp.TimeTest do
  use TimeManagerApp.DataCase

  import TimeManagerApp.TimeFixtures

  alias TimeManagerApp.Time

  describe "clocks" do
    alias TimeManagerApp.Time.Clock

    import TimeManagerApp.TimeFixtures

    @invalid_attrs %{status: nil, time: nil}

    test "list_clocks/0 returns all clocks" do
      clock = clock_fixture()
      assert Time.list_clocks() == [clock]
    end

    test "get_clock!/1 returns the clock with given id" do
      clock = clock_fixture()
      assert Time.get_clock!(clock.id) == clock
    end

    test "create_clock_for_user/1 with valid data creates a clock" do
      valid_attrs = %{status: true, time: ~U[2024-10-06 14:20:00Z]}

      assert {:ok, %Clock{} = clock} = Time.create_clock_for_user(valid_attrs)
      assert clock.status == true
      assert clock.time == ~U[2024-10-06 14:20:00Z]
    end

    test "create_clock_for_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Time.create_clock_for_user(@invalid_attrs)
    end

    test "update_clock/2 with valid data updates the clock" do
      clock = clock_fixture()
      update_attrs = %{status: false, time: ~U[2024-10-07 14:20:00Z]}

      assert {:ok, %Clock{} = clock} = Time.update_clock(clock, update_attrs)
      assert clock.status == false
      assert clock.time == ~U[2024-10-07 14:20:00Z]
    end

    test "update_clock/2 with invalid data returns error changeset" do
      clock = clock_fixture()
      assert {:error, %Ecto.Changeset{}} = Time.update_clock(clock, @invalid_attrs)
      assert clock == Time.get_clock!(clock.id)
    end

    test "delete_clock/1 deletes the clock" do
      clock = clock_fixture()
      assert {:ok, %Clock{}} = Time.delete_clock(clock)
      assert_raise Ecto.NoResultsError, fn -> Time.get_clock!(clock.id) end
    end

    test "change_clock/1 returns a clock changeset" do
      clock = clock_fixture()
      assert %Ecto.Changeset{} = Time.change_clock(clock)
    end
  end

  describe "workingtime" do
    alias TimeManagerApp.Time.WorkingTime

    import TimeManagerApp.TimeFixtures

    @invalid_attrs %{end: nil, start: nil}

    test "list_workingtime/0 returns all workingtime" do
      workingtime = workingtime_fixture()
      assert Time.list_workingtime() == [workingtime]
    end

    test "get_workingtime!/1 returns the workingtime with given id" do
      workingtime = workingtime_fixture()
      assert Time.get_workingtime!(workingtime.id) == workingtime
    end

    test "create_workingtime_for_user/1 with valid data creates a workingtime" do
      valid_attrs = %{end: ~U[2024-10-06 14:20:00Z], start: ~U[2024-10-06 14:20:00Z]}

      assert {:ok, %WorkingTime{} = workingtime} = Time.create_workingtime_for_user(valid_attrs)
      assert workingtime.end == ~U[2024-10-06 14:20:00Z]
      assert workingtime.start == ~U[2024-10-06 14:20:00Z]
    end

    test "create_workingtime_for_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Time.create_workingtime_for_user(@invalid_attrs)
    end

    test "update_workingtime/2 with valid data updates the workingtime" do
      workingtime = workingtime_fixture()
      update_attrs = %{end: ~U[2024-10-07 14:20:00Z], start: ~U[2024-10-07 14:20:00Z]}

      assert {:ok, %WorkingTime{} = workingtime} =
               Time.update_workingtime(workingtime, update_attrs)

      assert workingtime.end == ~U[2024-10-07 14:20:00Z]
      assert workingtime.start == ~U[2024-10-07 14:20:00Z]
    end

    test "update_workingtime/2 with invalid data returns error changeset" do
      workingtime = workingtime_fixture()
      assert {:error, %Ecto.Changeset{}} = Time.update_workingtime(workingtime, @invalid_attrs)
      assert workingtime == Time.get_workingtime!(workingtime.id)
    end

    test "delete_workingtime/1 deletes the workingtime" do
      workingtime = workingtime_fixture()
      assert {:ok, %WorkingTime{}} = Time.delete_workingtime(workingtime)
      assert_raise Ecto.NoResultsError, fn -> Time.get_workingtime!(workingtime.id) end
    end

    test "change_workingtime/1 returns a workingtime changeset" do
      workingtime = workingtime_fixture()
      assert %Ecto.Changeset{} = Time.change_workingtime(workingtime)
    end
  end
end
