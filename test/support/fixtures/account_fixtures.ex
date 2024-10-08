defmodule TimeManagerApp.AccountFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManagerApp.Account` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "test@test.com",
        username: "Tester"
      })
      |> TimeManagerApp.Account.create_user()

    user
  end
end
