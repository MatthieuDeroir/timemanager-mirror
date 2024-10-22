defmodule TimeManagerApp.Clocks do
  @moduledoc """
  The Clocks context.
  """

  alias TimeManagerApp.Repo
  # Ensure the correct alias is used
  alias TimeManagerApp.Clocks.Clock
  alias TimeManagerApp.WorkingTimes
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

  @doc """
  Creates a clock for a user. If the clock has `status: false`, it will create a corresponding working time.
  """
  def create_clock_for_user(user_id, attrs \\ %{}) do
    case do_create_clock_for_user(user_id, attrs) do
      {:ok, clock} ->
        # Check if the clock-out status is false
        if clock.status == false do
          # Attempt to create the corresponding working time
          WorkingTimes.create_working_time_after_clock_out(user_id, clock)
        end

        {:ok, clock}

      {:error, changeset} ->
        {:error, changeset}
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
