defmodule TimeManagerApp.WorkingTimes do
  @moduledoc """
  The Time context.
  """

  import Ecto.Query, warn: false
  alias TimeManagerApp.Repo
  alias TimeManagerApp.Clocks.Clock
  alias TimeManagerApp.WorkingTimes.WorkingTime

  @doc """
  Creates a working time entry when a user clocks out (status: false) using the last clock-in time.
  """
  def create_working_time_after_clock_out(user_id, clock_out) do
    # Retrieve the last clock-in (status == true)
    case get_last_clock_with_status_before_time(user_id, true, clock_out.time) do
      nil ->
        {:error, :no_matching_clock_in}

      last_clock_in ->
        working_time_params = %{
          "start" => last_clock_in.time,
          "end" => clock_out.time,
          "user_id" => user_id
        }

        %WorkingTime{}
        |> WorkingTime.changeset(working_time_params)
        |> Repo.insert()
    end
  end

  @doc """
  Retrieve the last clock-in event (status: true) for a user before a given time.
  """
  def get_last_clock_with_status_before_time(user_id, status, time) do
    Clock
    |> where([c], c.user_id == ^user_id and c.status == ^status and c.time <= ^time)
    |> order_by([c], desc: c.time)
    |> limit(1)
    |> Repo.one()
  end

  # --- WorkingTime Functions ---

  @doc """
  Fetches a specific working time by its ID and ensures that it belongs to the given user.
  Returns `nil` if the working time is not found or does not belong to the user.
  """
  def get_workingtime(user_id, workingtime_id) do
    Repo.get_by(WorkingTime, id: workingtime_id, user_id: user_id)
  end

  def get_workingtime_by_id(id) do
    Repo.get(WorkingTime, id)
  end

  @doc """
  Returns the list of working times for a specific user. You can optionally filter by a date range.
  """
  def list_workingtime_for_user(user_id, start_datetime \\ nil, end_datetime \\ nil)

  # Fetch all working times for a user
  def list_workingtime_for_user(user_id, nil, nil) do
    Repo.all(
      from(wt in WorkingTime,
        where: wt.user_id == ^user_id
      )
    )
  end

  # Fetch working times for a user starting from a specific datetime
  def list_workingtime_for_user(user_id, start_datetime, nil) do
    Repo.all(
      from(wt in WorkingTime,
        where: wt.user_id == ^user_id and wt.start >= ^start_datetime
      )
    )
  end

  # Fetch working times for a user between a specific start and end datetime
  def list_workingtime_for_user(user_id, start_datetime, end_datetime) do
    Repo.all(
      from(wt in WorkingTime,
        where: wt.user_id == ^user_id and wt.start >= ^start_datetime and wt.end <= ^end_datetime
      )
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
    case Repo.delete(workingtime) do
      {:ok, deleted_workingtime} -> {:ok, deleted_workingtime}
      {:error, changeset} -> {:error, changeset}
    end
  end
end
