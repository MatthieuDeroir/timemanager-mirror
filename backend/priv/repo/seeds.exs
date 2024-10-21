# priv/repo/seeds.exs

alias TimeManagerApp.Repo
alias TimeManagerApp.Roles.Role
alias TimeManagerApp.Teams.Team
alias TimeManagerApp.Users.User
alias TimeManagerApp.Clocks.Clock
alias TimeManagerApp.WorkingTimes.WorkingTime

defmodule TimeManagerApp.Seeds do
  def run do
    # Clear existing data
    # Clear existing data
    Repo.delete_all(WorkingTime)
    Repo.delete_all(Clock)
    Repo.delete_all(User)
    Repo.delete_all(Role)
    Repo.delete_all(Team)

    # Create roles
    roles = [
      %{"name" => "admin"},
      %{"name" => "general_manager"},
      %{"name" => "manager"},
      %{"name" => "employee"}
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
    general_manager_role = Repo.get_by(Role, name: "general_manager")
    admin_role = Repo.get_by(Role, name: "admin")

    comptability_team = Repo.get_by(Team, name: "comptability")
    security_team = Repo.get_by(Team, name: "security")
    it_team = Repo.get_by(Team, name: "it")

    # Create users with complete information
    # Create users with complete information
    users = [
      %User{
        firstname: "Alice",
        lastname: "Johnson",
        address: "123 Maple Street",
        phone: "555-1234",
        birthdate: ~D[1990-01-15],
        gender: "Female",
        salary: 50000.00,
        position: "Accountant",
        start_date: ~D[2015-06-01],
        end_date: nil,
        address: "123 Maple Street",
        phone: "555-1234",
        birthdate: ~D[1990-01-15],
        gender: "Female",
        salary: 50000.00,
        position: "Accountant",
        start_date: ~D[2015-06-01],
        end_date: nil,
        username: "alice.johnson",
        email: "alice@example.com",
        password: "password",
        role_id: employee_role.id,
        teams: [comptability_team],
        password: "password",
        role_id: employee_role.id,
        teams: [comptability_team]
      },
      %User{
        firstname: "Bob",
        lastname: "Smith",
        address: "456 Oak Avenue",
        phone: "555-5678",
        birthdate: ~D[1985-07-22],
        gender: "Male",
        salary: 52000.00,
        position: "Security Analyst",
        start_date: ~D[2016-08-15],
        end_date: nil,
        address: "456 Oak Avenue",
        phone: "555-5678",
        birthdate: ~D[1985-07-22],
        gender: "Male",
        salary: 52000.00,
        position: "Security Analyst",
        start_date: ~D[2016-08-15],
        end_date: nil,
        username: "bob.smith",
        email: "bob@example.com",
        password: "password",
        role_id: employee_role.id,
        teams: [security_team]
        password: "password",
        role_id: employee_role.id,
        teams: [security_team]
      },
      %User{
        firstname: "Charlie",
        lastname: "Brown",
        address: "789 Pine Road",
        phone: "555-8765",
        birthdate: ~D[1992-03-05],
        gender: "Male",
        salary: 55000.00,
        position: "Software Engineer",
        start_date: ~D[2018-01-10],
        end_date: nil,
        address: "789 Pine Road",
        phone: "555-8765",
        birthdate: ~D[1992-03-05],
        gender: "Male",
        salary: 55000.00,
        position: "Software Engineer",
        start_date: ~D[2018-01-10],
        end_date: nil,
        username: "charlie.brown",
        email: "charlie@example.com",
        password: "password",
        role_id: employee_role.id,
        teams: [it_team]
        password: "password",
        role_id: employee_role.id,
        teams: [it_team]
      },
      %User{
        firstname: "Diana",
        lastname: "Prince",
        address: "321 Elm Street",
        phone: "555-4321",
        birthdate: ~D[1988-11-30],
        gender: "Female",
        salary: 53000.00,
        position: "System Administrator",
        start_date: ~D[2017-04-20],
        end_date: nil,
        address: "321 Elm Street",
        phone: "555-4321",
        birthdate: ~D[1988-11-30],
        gender: "Female",
        salary: 53000.00,
        position: "System Administrator",
        start_date: ~D[2017-04-20],
        end_date: nil,
        username: "diana.prince",
        email: "diana@example.com",
        password: "password",
        role_id: employee_role.id,
        teams: [it_team]
        password: "password",
        role_id: employee_role.id,
        teams: [it_team]
      },
      %User{
        firstname: "Eve",
        lastname: "Adams",
        address: "654 Birch Lane",
        phone: "555-6789",
        birthdate: ~D[1982-09-17],
        gender: "Female",
        salary: 70000.00,
        position: "Team Manager",
        start_date: ~D[2014-02-25],
        end_date: nil,
        address: "654 Birch Lane",
        phone: "555-6789",
        birthdate: ~D[1982-09-17],
        gender: "Female",
        salary: 70000.00,
        position: "Team Manager",
        start_date: ~D[2014-02-25],
        end_date: nil,
        username: "eve.adams",
        email: "eve@example.com",
        password: "password",
        role_id: manager_role.id,
        teams: [comptability_team]
        password: "password",
        role_id: manager_role.id,
        teams: [comptability_team]
      },
      %User{
        firstname: "Frank",
        lastname: "Miller",
        address: "987 Cedar Court",
        phone: "555-9876",
        birthdate: ~D[1991-06-12],
        gender: "Male",
        salary: 51000.00,
        position: "Security Guard",
        start_date: ~D[2019-09-05],
        end_date: nil,
        address: "987 Cedar Court",
        phone: "555-9876",
        birthdate: ~D[1991-06-12],
        gender: "Male",
        salary: 51000.00,
        position: "Security Guard",
        start_date: ~D[2019-09-05],
        end_date: nil,
        username: "frank.miller",
        email: "frank@example.com",
        password: "password",
        role_id: employee_role.id,
        teams: [security_team]
        password: "password",
        role_id: employee_role.id,
        teams: [security_team]
      },
      %User{
        firstname: "Grace",
        lastname: "Harris",
        address: "159 Spruce Way",
        phone: "555-2468",
        birthdate: ~D[1993-12-08],
        gender: "Female",
        salary: 54000.00,
        position: "Network Engineer",
        start_date: ~D[2018-07-16],
        end_date: nil,
        address: "159 Spruce Way",
        phone: "555-2468",
        birthdate: ~D[1993-12-08],
        gender: "Female",
        salary: 54000.00,
        position: "Network Engineer",
        start_date: ~D[2018-07-16],
        end_date: nil,
        username: "grace.harris",
        email: "grace@example.com",
        password: "password",
        role_id: employee_role.id,
        teams: [it_team]
        password: "password",
        role_id: employee_role.id,
        teams: [it_team]
      },
      %User{
        firstname: "Henry",
        lastname: "Lee",
        address: "753 Willow Drive",
        phone: "555-1357",
        birthdate: ~D[1987-02-27],
        gender: "Male",
        salary: 56000.00,
        position: "Database Administrator",
        start_date: ~D[2017-11-03],
        end_date: nil,
        address: "753 Willow Drive",
        phone: "555-1357",
        birthdate: ~D[1987-02-27],
        gender: "Male",
        salary: 56000.00,
        position: "Database Administrator",
        start_date: ~D[2017-11-03],
        end_date: nil,
        username: "henry.lee",
        email: "employee@employee.com",
        password: "password",
        role_id: employee_role.id,
        teams: [it_team]
      },
      %User{
        firstname: "Isabella",
        lastname: "Taylor",
        address: "852 Walnut Street",
        phone: "555-8642",
        birthdate: ~D[1994-05-19],
        gender: "Female",
        salary: 52000.00,
        position: "Accountant",
        start_date: ~D[2019-03-11],
        end_date: nil,
        address: "852 Walnut Street",
        phone: "555-8642",
        birthdate: ~D[1994-05-19],
        gender: "Female",
        salary: 52000.00,
        position: "Accountant",
        start_date: ~D[2019-03-11],
        end_date: nil,
        username: "isabella.taylor",
        email: "manager@manager.com",
        password: "password",
        role_id: manager_role.id,
        teams: [comptability_team]
      },
      %User{
        firstname: "Jack",
        lastname: "Wilson",
        address: "456 Maple Street",
        phone: "555-7777",
        birthdate: ~D[1983-08-14],
        gender: "Male",
        salary: 72000.00,
        position: "Team Manager",
        start_date: ~D[2013-05-22],
        end_date: nil,
        address: "456 Maple Street",
        phone: "555-7777",
        birthdate: ~D[1983-08-14],
        gender: "Male",
        salary: 72000.00,
        position: "Team Manager",
        start_date: ~D[2013-05-22],
        end_date: nil,
        username: "jack.wilson",
        email: "generalmanager@generalmanager.com",
        password: "password",
        role_id: general_manager_role.id,
        teams: [it_team]
      },
      %User{
        firstname: "Liam",
        lastname: "Garcia",
        address: "789 Oak Avenue",
        phone: "555-9999",
        birthdate: ~D[1980-04-09],
        gender: "Male",
        salary: 90000.00,
        position: "Administrator",
        start_date: ~D[2010-01-01],
        end_date: nil,
        address: "789 Oak Avenue",
        phone: "555-9999",
        birthdate: ~D[1980-04-09],
        gender: "Male",
        salary: 90000.00,
        position: "Administrator",
        start_date: ~D[2010-01-01],
        end_date: nil,
        username: "liam.garcia",
        email: "admin@admin.com",
        password: "password",
        role_id: admin_role.id,
        teams: []
      }
    ]

    # Insert users with changeset validations
    # Insert users with changeset validations
    Enum.each(users, fn user ->
      %User{}
      |> User.changeset(Map.from_struct(user))
      |> Repo.insert!()
      %User{}
      |> User.changeset(Map.from_struct(user))
      |> Repo.insert!()
    end)

    # Create working times for the last 7 days for each user
    # Create working times for the last 7 days for each user
    for user <- Repo.all(User) do
      for day <- 0..6 do
        date = Date.utc_today() |> Date.add(-day)

        working_times = [
          %WorkingTime{
            start: create_datetime(date, 8, 0),
            end: create_datetime(date, 12, 0),
            user_id: user.id,
            type: "regular"
          },
          %WorkingTime{
            start: create_datetime(date, 14, 0),
            end: create_datetime(date, 18, 0),
            user_id: user.id,
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
