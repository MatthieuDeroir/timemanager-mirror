# seeds.exs

alias TimeManagerApp.Repo
alias TimeManagerApp.Roles.Role
alias TimeManagerApp.Teams.Team
alias TimeManagerApp.Users.User
alias TimeManagerApp.WorkingTimes.WorkingTime
alias TimeManagerApp.Clocks.Clock

# Define Roles
roles = [
  %{id: 1, name: "admin"},
  %{name: "general_manager"},
  %{name: "manager"},
  %{name: "employee"}
]

# Insert or update Roles
Enum.each(roles, fn role_attrs ->
  Repo.insert!(
    %Role{}
    |> Role.changeset(role_attrs),
    on_conflict: [set: [name: role_attrs.name]],
    conflict_target: [:name]
  )
end)

# Fetch Roles by name
admin_role = Repo.get_by!(Role, name: "admin")
general_manager_role = Repo.get_by!(Role, name: "general_manager")
manager_role = Repo.get_by!(Role, name: "manager")
employee_role = Repo.get_by!(Role, name: "employee")

# Create Teams
teams = [
  %{name: "Team Alpha"},
  %{name: "Team Beta"},
  %{name: "Team Gamma"}
]

created_teams =
  Enum.map(teams, fn team_attrs ->
    Repo.insert!(
      %Team{}
      |> Team.changeset(team_attrs),
      on_conflict: [set: [name: team_attrs.name]],
      conflict_target: [:name]
    )
  end)

# Create Admin User
admin_user_attrs = %{
  firstname: "Admin",
  lastname: "User",
  username: "admin",
  email: "admin@example.com",
  password: "password",
  role_id: admin_role.id
}

# Insert or update Admin User
Repo.insert!(
  %User{}
  |> User.changeset(admin_user_attrs),
  on_conflict: [set: [email: admin_user_attrs.email]],
  conflict_target: [:email]
)

# Create General Managers and Managers per Team
Enum.each(created_teams, fn team ->
  # General Manager
  gm_attrs = %{
    firstname: "GeneralManager",
    lastname: team.name,
    username: "gm_#{String.downcase(team.name)}",
    email: "gm_#{String.downcase(team.name)}@example.com",
    password: "password",
    role_id: general_manager_role.id,
    team_ids: [team.id]
  }

  Repo.insert!(
    %User{}
    |> User.changeset(gm_attrs),
    on_conflict: [set: [email: gm_attrs.email]],
    conflict_target: [:email]
  )

  # Manager
  manager_attrs = %{
    firstname: "Manager",
    lastname: team.name,
    username: "manager_#{String.downcase(team.name)}",
    email: "manager_#{String.downcase(team.name)}@example.com",
    password: "password",
    role_id: manager_role.id,
    team_ids: [team.id]
  }

  Repo.insert!(
    %User{}
    |> User.changeset(manager_attrs),
    on_conflict: [set: [email: manager_attrs.email]],
    conflict_target: [:email]
  )
end)

# Create Employees
employee_role_id = employee_role.id

employee_users =
  Enum.map(1..13, fn i ->
    team_ids = Enum.map(Enum.take_random(created_teams, Enum.random(1..3)), & &1.id)

    employee_attrs = %{
      firstname: "Employee#{i}",
      lastname: "Lastname#{i}",
      username: "employee#{i}",
      email: "employee#{i}@example.com",
      password: "password",
      role_id: employee_role_id,
      team_ids: team_ids,
      salary: Enum.random(30_000..50_000)
    }

    Repo.insert!(
      %User{}
      |> User.changeset(employee_attrs),
      on_conflict: [set: [email: employee_attrs.email]],
      conflict_target: [:email]
    )
  end)

# Create Working Times and Clocks for Employees
Enum.each(employee_users, fn user ->
  Enum.each(1..2, fn _ ->
    # Generate random start time between 8:00 and 16:00
    start_hour = Enum.random(8..16)
    start_minute = Enum.random(0..59)
    today = Date.utc_today()
    {:ok, start_time} = DateTime.new(today, Time.new!(start_hour, start_minute, 0), "Etc/UTC")

    # Generate random duration between 1 and 2 hours
    duration_minutes = Enum.random(60..120)
    end_time = DateTime.add(start_time, duration_minutes * 60, :second)

    # Ensure end_time is before 18:00
    {:ok, end_of_day} = DateTime.new(today, ~T[18:00:00], "Etc/UTC")

    end_time =
      if DateTime.compare(end_time, end_of_day) == :gt do
        end_of_day
      else
        end_time
      end

    # Create Working Time
    working_time_attrs = %{
      start: start_time,
      end: end_time,
      user_id: user.id
    }

    Repo.insert!(
      %WorkingTime{}
      |> WorkingTime.changeset(working_time_attrs)
    )

    # Create Clock-in
    clock_in_attrs = %{
      time: start_time,
      status: true,
      user_id: user.id
    }

    Repo.insert!(
      %Clock{}
      |> Clock.changeset(clock_in_attrs)
    )

    # Create Clock-out
    clock_out_attrs = %{
      time: end_time,
      status: false,
      user_id: user.id
    }

    Repo.insert!(
      %Clock{}
      |> Clock.changeset(clock_out_attrs)
    )
  end)
end)
