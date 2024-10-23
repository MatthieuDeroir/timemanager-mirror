# TimeManagerApp

To start your Phoenix server:

  * Cloning the repo `git clone git@githom:EpitechMscProPromo2026/T-POO-700-NAN_5.git`
  * Run `mix setup` to install and setup dependencies
  * Run `mix ecto.migrate` to init database's
  * Start Phoenix endpoint with (OLD) `mix phx.server`, (NEW) `source .env && mix phx.server` (on linux)
  * Run `mix test` to start test

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

---

## Context

Gotham City Hall wants to deploy the application on several platforms (mainly computers and different types of terminals). It is also considering a mobile version.
The goal of this project is to create a platform-independent API for exchanging and storing data.

---

## Populate the database

To populate the database, you can use the following command:
* mix run priv/repo/seeds.exs

---

## Docs

 * Database schema: /docs/database_schema.png
 * Collection Postman: /docs/TimeManager.postman_collection
 * Swagger: https://localhost:4000/api/swagger
 * Generate swagger : mix phx.swagger.generate

 ---
 
 ## Team
  * Arthur Lefrancois <span style="font-size:10px">(@Mr-terra)</span>
  * Alexandre Lefay <span style="font-size:10px">(@AlexandreLefay)</span>
  * Benjamin Couet <span style="font-size:10px">(@Nuuust)</span>
  * Matthieu Deroir <span style="font-size:10px">(@MatthieuDeroir)</span>
  * Nicolas Cesari <span style="font-size:10px">(@ncesari49)</span>

  ---
  
## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

