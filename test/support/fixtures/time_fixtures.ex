defmodule TimeManagerApp.TimeFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManagerApp.Time` context.
  """

  @doc """
  Generate a clock.
  """
  def clock_fixture(attrs \\ %{}) do
    {:ok, clock} =
      attrs
      |> Enum.into(%{
        status: true,
        time: ~U[2024-10-06 14:20:00Z]
      })
      |> TimeManagerApp.Time.create_clock_for_user()

    clock
  end

  @doc """
  Generate a workingtime.
  """
  def workingtime_fixture(attrs \\ %{}) do
    {:ok, workingtime} =
      attrs
      |> Enum.into(%{
        end: ~U[2024-10-06 14:20:00Z],
        start: ~U[2024-10-06 14:20:00Z]
      })
      |> TimeManagerApp.Time.create_workingtime_for_user()

    workingtime
  end
end
