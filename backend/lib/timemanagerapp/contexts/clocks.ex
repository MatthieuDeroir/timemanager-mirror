defmodule TimeManagerApp.Clocks do
  @moduledoc """
  The Clocks context.
  """

  alias TimeManagerApp.Repo
  # Ensure the correct alias is used
  alias TimeManagerApp.Clocks.Clock
  import Ecto.Query, only: [from: 2]

  # --- Clocks Functions ---

  @doc """
  Returns the list of all clocks.
  """
  def list_all_clocks do
    Repo.all(Clock)
  end

  @doc """
  Returns the list of clocks for a specific user.
  """
  def list_clocks_for_user(user_id) do
    from(c in Clock, where: c.user_id == ^user_id)
    |> Repo.all()
  end

  def create_clock_for_user(user_id, attrs \\ %{}) do
    case do_create_clock_for_user(user_id, attrs) do
      {:ok, clock} -> {:ok, clock}
      {:error, changeset} -> {:error, changeset}
    end
  end

  defp do_create_clock_for_user(user_id, attrs) do
    normalized_attrs = attrs |> Map.new(fn {k, v} -> {String.to_atom(to_string(k)), v} end)

    %Clock{}
    |> Clock.changeset(Map.put(normalized_attrs, :user_id, user_id))
    |> Repo.insert()
  end

  # def create_clock_for_user(user_id, attrs) do
  #   attrs
  #   |> Enum.into(%{}, fn {key, value} -> {String.to_atom(key), value} end)
  #   |> Map.put(:user_id, user_id)
  #   |> Clock.changeset()
  #   |> Repo.insert()
  # end

  # def create_clock_for_user(user_id, attrs \\ %{}) do
  #   case do_create_clock_for_user(user_id, attrs) do
  #     {:ok, clock} -> {:ok, clock}
  #     {:error, changeset} -> {:error, changeset}
  #   end
  # end

  # defp do_create_clock_for_user(user_id, attrs) do
  #   %Clock{}
  #   |> Clock.changeset(Map.put(attrs, "user_id", user_id))
  #   |> Repo.insert()
  # end

  def get_clock(user_id, id) do
    Repo.get_by(Clock, id: id, user_id: user_id)
  end
end
