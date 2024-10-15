defmodule TimeManagerApp.ClocksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManagerApp.Clocks` context.
  """

  @doc """
  Generate a clock.
  """
  def clock_fixture(attrs \\ %{}) do
    {:ok, clock} =
      attrs
      |> Enum.into(%{
        status: "some status",
        time: ~U[2024-10-13 14:48:00Z]
      })
      |> TimeManagerApp.Clocks.create_clock()

    clock
  end
end
