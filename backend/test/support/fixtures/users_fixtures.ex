defmodule TimeManagerApp.UsersFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TimeManagerApp.Users` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
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
      })
      |> TimeManagerApp.Users.create_user()

    user
  end
end
