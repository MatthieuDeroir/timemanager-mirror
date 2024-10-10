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
    Repo.all(from(c in Clock, where: c.user_id == ^user_id))
  end

  def create_clock_for_user(user_id, attrs \\ %{}) do
    result =
      Repo.transaction(fn ->
        # Create the clock
        case do_create_clock_for_user(user_id, attrs) do
          {:ok, clock} ->
            # If clock.status is false (clocking out), handle working time
            if clock.status == false do
              case create_working_time_after_clock_out(user_id, clock) do
                {:ok, _working_time} -> {:ok, clock}
                {:error, reason} -> Repo.rollback(reason)
              end
            else
              {:ok, clock}
            end

          {:error, changeset} ->
            Repo.rollback(changeset)
        end
      end)

    # Unwrap the result from the transaction
    case result do
      {:ok, {:ok, clock}} -> {:ok, clock}
      {:error, reason} -> {:error, reason}
      {:error, %Ecto.Changeset{} = changeset} -> {:error, changeset}
      other -> other
    end
  end

  # Helper function to create the clock
  defp do_create_clock_for_user(user_id, attrs) do
    %Clock{}
    |> Clock.changeset(Map.put(attrs, "user_id", user_id))
    |> Repo.insert()
  end

  def get_clock(user_id, id) do
    Repo.get_by(Clock, id: id, user_id: user_id)
  end

  # Function to create a working time after clocking out
  defp create_working_time_after_clock_out(user_id, clock_out) do
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

  # Function to retrieve the last clock with a given status for a user before a specific time
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

  @doc """
  Returns the list of working times for a specific user within a date range.
  """
  def list_workingtime_for_user(user_id, start_datetime, end_datetime) do
    Repo.all(
      from(wt in WorkingTime,
        where: wt.user_id == ^user_id and wt.start >= ^start_datetime and wt.end <= ^end_datetime
      )
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

  # Fetch all working times for a user
  def list_workingtime_for_user(user_id) do
    Repo.all(
      from(wt in WorkingTime,
        where: wt.user_id == ^user_id
      )
    )
  end

  # Fetch working times for a user starting from a specific datetime
  def list_workingtime_for_user(user_id, start_datetime) do
    Repo.all(
      from(wt in WorkingTime,
        where: wt.user_id == ^user_id and wt.start_time >= ^start_datetime
      )
    )
  end

  # Fetch working times for a user between a specific start and end datetime
  def list_workingtime_for_user(user_id, start_datetime, end_datetime) do
    Repo.all(
      from(wt in WorkingTime,
        where:
          wt.user_id == ^user_id and
            wt.start_time >= ^start_datetime and
            wt.end_time <= ^end_datetime
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
    Repo.delete(workingtime)
    {:ok, workingtime}
  end
end
