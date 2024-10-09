alias TimeManagerApp.Repo
alias TimeManagerApp.Account.User
alias TimeManagerApp.Time.Clock
alias TimeManagerApp.Time.WorkingTime

# Import Faker for generating random data
{:ok, _} = Application.ensure_all_started(:faker)

# Create Users
users =
  for _ <- 1..50 do
    %User{
      username: Faker.Internet.user_name(),
      email: Faker.Internet.email()
    }
    |> Repo.insert!()
  end

# Create Clocks for Users
for user <- users do
  %Clock{
    time:
      Faker.DateTime.between(~U[2022-01-01 00:00:00Z], ~U[2024-01-01 00:00:00Z])
      # Inline the truncation
      |> DateTime.truncate(:second),
    status: Enum.random([true, false]),
    user_id: user.id
  }
  |> Repo.insert!()
end

# Create Working Time for Users
for user <- users do
  start_time =
    Faker.DateTime.between(~U[2022-01-01 08:00:00Z], ~U[2023-01-01 17:00:00Z])
    |> DateTime.truncate(:second)

  # Generate a date 8 days forward
  end_time =
    Faker.DateTime.forward(8)
    |> DateTime.truncate(:second)

  %WorkingTime{
    start: start_time,
    end: end_time,
    user_id: user.id
  }
  |> Repo.insert!()
end

IO.puts("Seeding completed successfully.")
