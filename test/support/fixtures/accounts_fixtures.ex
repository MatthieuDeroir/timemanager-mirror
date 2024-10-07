defmodule TimeManagerApp.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManagerApp.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        created_at: ~U[2024-10-06 13:58:00Z],
        first_name: "some first_name",
        inserted_at: ~U[2024-10-06 13:58:00Z],
        last_name: "some last_name"
      })
      |> TimeManagerApp.Accounts.create_user()

    user
  end
end
