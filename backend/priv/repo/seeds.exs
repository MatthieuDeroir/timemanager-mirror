alias TimeManagerApp.Repo
alias TimeManagerApp.Account.User
alias TimeManagerApp.Time.Clock
alias TimeManagerApp.Time.WorkingTime

# Clear existing data
# TODO: make controller to delete all data

# Import Faker for generating random data
{:ok, _} = Application.ensure_all_started(:faker)

# TODO: improve data generation to meet time constraints (a working time is made with a pair of status true and false clock, a working time must happen in a day | 1 user can have multiple working times accross multiple day)

# Create Users
users =
  for _ <- 1..50 do
    %User{
      username: Faker.Internet.user_name(),
      email: Faker.Internet.email()
    }
    |> Repo.insert!()
  end

# Create Working Times with Clocks for Users
for user <- users do
  # Generate multiple working times for the same user
  for _ <- 1..:rand.uniform(5) do
    # Generate start time and end time for the working day
    start_time =
      Faker.DateTime.between(~U[2023-01-01 08:00:00Z], ~U[2023-01-01 09:00:00Z])
      |> DateTime.truncate(:second)

    # Ensure the end time happens on the same day, after the start time
    # Within 8 hours
    end_time =
      Faker.DateTime.between(start_time, DateTime.add(start_time, 8 * 3600))
      |> DateTime.truncate(:second)

    # Insert clocks (start and end)
    %Clock{
      time: start_time,
      status: true,
      user_id: user.id
    }
    |> Repo.insert!()

    %Clock{
      time: end_time,
      status: false,
      user_id: user.id
    }
    |> Repo.insert!()

    # Insert working time
    %WorkingTime{
      start: start_time,
      end: end_time,
      user_id: user.id
    }
    |> Repo.insert!()
  end
end

IO.puts("Seeding completed successfully.")
