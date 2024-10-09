defmodule TimeManagerApp.TimeFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManagerApp.Time` context.
  """

  alias TimeManagerApp.Repo
  alias TimeManagerApp.Account.User
  alias TimeManagerApp.Time

  @doc """
  Generate a user and persist it to the database.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        # Define default user attributes here
        name: "Test User",
        email: "test@example.com"
        # Add other required fields
      })
      |> Accounts.create_user()

    user
  end

  @doc """
  Generate a clock.
  """
  def clock_fixture(attrs \\ %{}) do
    # Assuming you have a user_fixture function defined
    user = user_fixture()

    # Merge default clock attributes with any provided attributes
    {:ok, clock} =
      attrs
      |> Enum.into(%{status: true, time: ~U[2024-10-06 14:20:00Z], user_id: user.id})
      |> TimeManagerApp.Time.create_clock()

    clock
  end

  @doc """
  Generate a not-working clock.
  """
  def not_working_clock_fixture(attrs \\ %{}) do
    user = user_fixture()

    {:ok, clock} =
      attrs
      |> Enum.into(%{
        status: false,
        time: ~U[2024-10-06 14:20:00Z],
        user_id: user.id
      })
      |> Time.create_clock()

    clock
  end

  @doc """
  Generate a working time.
  """
  def workingtime_fixture(attrs \\ %{}) do
    user = user_fixture()

    {:ok, workingtime} =
      attrs
      |> Enum.into(%{
        # Replace with your actual attributes for WorkingTime
        start_time: ~U[2024-10-06 09:00:00Z],
        end_time: ~U[2024-10-06 17:00:00Z],
        user_id: user.id
      })
      |> Time.create_workingtime()

    workingtime
  end
end
