# lib/time_manager_app/time.ex

defmodule TimeManagerApp.Time do
  @moduledoc """
  The Time context.
  """

  import Ecto.Query, warn: false
  alias TimeManagerApp.Repo

  alias TimeManagerApp.Time.Clock
  alias TimeManagerApp.Time.WorkingTime

  # --- Clocks Functions ---

  @doc """
  Returns the list of clocks for a specific user.
  """
  def list_clocks_for_user(user_id) do
    Repo.all(from c in Clock, where: c.user_id == ^user_id)
  end

  @doc """
  Creates a clock associated with a specific user.
  """
  def create_clock_for_user(user_id, attrs \\ %{}) do
    %Clock{}
    |> Clock.changeset(Map.put(attrs, "user_id", user_id))
    |> Repo.insert()
  end

  # --- WorkingTime Functions ---

  @doc """
  Returns the list of working times for a specific user within a date range.
  """
  def list_working_time_for_user(user_id, start_datetime, end_datetime) do
    Repo.all(
      from wt in WorkingTime,
        where: wt.user_id == ^user_id and wt.start >= ^start_datetime and wt.end <= ^end_datetime
    )
  end

  def get_clock(user_id, id) do
    Repo.get_by(Clock, id: id, user_id: user_id)
  end

  @doc """
  Gets a single working time entry by ID.
  """
  def get_working_time!(id), do: Repo.get!(WorkingTime, id)

  @doc """
  Creates a working time entry associated with a specific user.
  """
  def create_working_time_for_user(user_id, attrs \\ %{}) do
    %WorkingTime{}
    |> WorkingTime.changeset(Map.put(attrs, "user_id", user_id))
    |> Repo.insert()
  end

  @doc """
  Updates a working time entry.
  """
  def update_working_time(%WorkingTime{} = working_time, attrs) do
    working_time
    |> WorkingTime.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a working time entry.
  """
  def delete_working_time(%WorkingTime{} = working_time) do
    Repo.delete(working_time)
    {:ok, working_time}
  end

end
