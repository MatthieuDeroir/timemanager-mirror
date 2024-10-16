# priv/repo/seeds.exs

alias TimeManagerApp.Repo
alias TimeManagerApp.Roles.Role
alias TimeManagerApp.Teams.Team
alias TimeManagerApp.Users.User
alias TimeManagerApp.Clocks.Clock
alias TimeManagerApp.WorkingTimes.WorkingTime

# Define a module for seeding
defmodule TimeManagerApp.Seeds do
  # Clear existing data
  def run do
    Repo.delete_all(WorkingTime)
    Repo.delete_all(Clock)
    Repo.delete_all(User)
    Repo.delete_all(Role)
    Repo.delete_all(Team)

    # Create roles
    roles = [
      %{"name" => "employee"},
      %{"name" => "manager"},
      %{"name" => "admin"}
    ]

    # Insert roles
    Enum.each(roles, fn role ->
      %Role{}
      |> Role.changeset(role)
      |> Repo.insert!()
    end)

    # Create teams
    teams = [
      %{"name" => "comptability"},
      %{"name" => "security"},
      %{"name" => "it"}
    ]

    # Insert teams
    Enum.each(teams, fn team ->
      %Team{}
      |> Team.changeset(team)
      |> Repo.insert!()
    end)

    # Get the inserted roles and teams
    employee_role = Repo.get_by(Role, name: "employee")
    manager_role = Repo.get_by(Role, name: "manager")
    admin_role = Repo.get_by(Role, name: "admin")

    comptability_team = Repo.get_by(Team, name: "comptability")
    security_team = Repo.get_by(Team, name: "security")
    it_team = Repo.get_by(Team, name: "it")

    # Create users with usernames
    users = [
      %User{
        firstname: "Alice",
        lastname: "Johnson",
        username: "alice.johnson",
        email: "alice@example.com",
        password_hash: "password",
        role_id: employee_role.id,
        team_id: comptability_team.id
      },
      %User{
        firstname: "Bob",
        lastname: "Smith",
        username: "bob.smith",
        email: "bob@example.com",
        password_hash: "password",
        role_id: employee_role.id,
        team_id: comptability_team.id
      },
      %User{
        firstname: "Charlie",
        lastname: "Brown",
        username: "charlie.brown",
        email: "charlie@example.com",
        password_hash: "password",
        role_id: employee_role.id,
        team_id: comptability_team.id
      },
      %User{
        firstname: "Diana",
        lastname: "Prince",
        username: "diana.prince",
        email: "diana@example.com",
        password_hash: "password",
        role_id: employee_role.id,
        team_id: comptability_team.id
      },
      %User{
        firstname: "Eve",
        lastname: "Adams",
        username: "eve.adams",
        email: "eve@example.com",
        password_hash: "password",
        role_id: manager_role.id,
        team_id: comptability_team.id
      },
      %User{
        firstname: "Frank",
        lastname: "Miller",
        username: "frank.miller",
        email: "frank@example.com",
        password_hash: "password",
        role_id: employee_role.id,
        team_id: security_team.id
      },
      %User{
        firstname: "Grace",
        lastname: "Harris",
        username: "grace.harris",
        email: "grace@example.com",
        password_hash: "password",
        role_id: employee_role.id,
        team_id: security_team.id
      },
      %User{
        firstname: "Henry",
        lastname: "Lee",
        username: "henry.lee",
        email: "henry@example.com",
        password_hash: "password",
        role_id: employee_role.id,
        team_id: security_team.id
      },
      %User{
        firstname: "Isabella",
        lastname: "Taylor",
        username: "isabella.taylor",
        email: "isabella@example.com",
        password_hash: "password",
        role_id: employee_role.id,
        team_id: security_team.id
      },
      %User{
        firstname: "Jack",
        lastname: "Wilson",
        username: "jack.wilson",
        email: "jack@example.com",
        password_hash: "password",
        role_id: manager_role.id,
        team_id: security_team.id
      },
      %User{
        firstname: "Liam",
        lastname: "Garcia",
        username: "liam.garcia",
        email: "liam@example.com",
        password_hash: "password",
        role_id: admin_role.id,
        team_id: it_team.id
      }
    ]

    # Insert users
    Enum.each(users, fn user ->
      Repo.insert!(user)
    end)

    # Create working times for the last 7 days for each employee
    for user <- Repo.all(User) do
      for day <- 0..6 do
        date = Date.utc_today() |> Date.add(-day)

        working_times = [
          %WorkingTime{
            # 08:00
            start: create_datetime(date, 8, 0),
            # 12:00
            end: create_datetime(date, 12, 0),
            user_id: user.id,
            # Set a default type value
            type: "regular"
          },
          %WorkingTime{
            # 14:00
            start: create_datetime(date, 14, 0),
            # 18:00
            end: create_datetime(date, 18, 0),
            user_id: user.id,
            # Set a default type value
            type: "regular"
          }
        ]

        # Insert working times individually
        Enum.each(working_times, fn working_time ->
          Repo.insert!(working_time)
        end)
      end
    end

    IO.puts("Seeding completed successfully!")
  end

  # Helper function to create DateTime in UTC
  defp create_datetime(date, hour, minute) do
    case Time.new(hour, minute, 0) do
      {:ok, time} ->
        date_time = NaiveDateTime.new(date, time)

        case date_time do
          {:ok, naive_dt} ->
            DateTime.from_naive!(naive_dt, "Etc/UTC")

          {:error, reason} ->
            IO.puts("Failed to create NaiveDateTime: #{reason}")
            nil
        end

      {:error, reason} ->
        IO.puts("Failed to create Time: #{reason}")
        nil
    end
  end
end

# Run the seeder
TimeManagerApp.Seeds.run()
