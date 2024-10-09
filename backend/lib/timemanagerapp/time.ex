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
  Returns the list of all clocks.
  """
  def list_all_clocks do
    Repo.all(Clock)
  end

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

  def get_clock(user_id, id) do
    Repo.get_by(Clock, id: id, user_id: user_id)
  end

  # --- WorkingTime Functions ---

  @doc """
  Returns the list of working times for a specific user within a date range.
  """
  def list_workingtime_for_user(user_id, start_datetime, end_datetime) do
    Repo.all(
      from wt in WorkingTime,
        where: wt.user_id == ^user_id and wt.start >= ^start_datetime and wt.end <= ^end_datetime
    )
  end

  @doc """
  Returns the list of all working times.
  """
  def list_all_workingtimes do
    Repo.all(WorkingTime)
  end

  @doc """
  Returns the list of working times for a specific user.
  """
  def list_workingtime_for_user(user_id) do
    Repo.all(from wt in WorkingTime, where: wt.user_id == ^user_id)
  end

  @doc """
  Returns the list of working times for a specific user within a date range.
  """
  def list_workingtime_for_user_and_time_range(user_id, start_datetime, end_datetime) do
    Repo.all(
      from wt in WorkingTime,
        where: wt.user_id == ^user_id and wt.start >= ^start_datetime and wt.end <= ^end_datetime
    )
  end

  @doc """
  Returns the list of working times within a date range.
  """
  def list_workingtime_for_time_range(start_datetime, end_datetime) do
    Repo.all(
      from wt in WorkingTime, where: wt.start >= ^start_datetime and wt.end <= ^end_datetime
    )
  end

  @doc """
  Creates a working time entry associated with a specific user.
  """
  def create_workingtime_for_user(user_id, attrs \\ %{}) do
    %WorkingTime{}
    |> WorkingTime.changeset(Map.put(attrs, "user_id", user_id))
    |> Repo.insert()
  end

  @doc """
  Updates a working time entry.
  """
  def update_workingtime(%WorkingTime{} = workingtime, attrs) do
    workingtime
    |> WorkingTime.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a working time entry.
  """
  def delete_workingtime(%WorkingTime{} = workingtime) do
    Repo.delete(workingtime)
    {:ok, workingtime}
  end
end
