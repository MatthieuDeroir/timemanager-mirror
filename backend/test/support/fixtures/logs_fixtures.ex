defmodule TimeManagerApp.LogsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManagerApp.Logs` context.
  """

  @doc """
  Generate a log.
  """
  def log_fixture(attrs \\ %{}) do
    {:ok, log} =
      attrs
      |> Enum.into(%{
        action: "some action",
        level: "some level",
        message: "some message"
      })
      |> TimeManagerApp.Logs.create_log()

    log
  end
end
