defmodule TimeManagerAppWeb.Swagger.ClockSwagger do
  use PhoenixSwagger

  # Définitions de schéma Swagger pour l'entité Clock
  def swagger_definitions do
    %{
      Clock:
        swagger_schema do
          title("Clock")
          description("A clock entry for a user")

          properties do
            id(:integer, "Clock ID", required: true)
            user_id(:integer, "User ID associated with the clock", required: true)
            time(:string, "Timestamp of the clock", required: true)
            status(:string, "Clock status (e.g., 'in' or 'out')", required: true)
          end
        end,
      CreateClock:
        swagger_schema do
          title("CreateClock")
          description("Schema for creating a clock entry")

          properties do
            clocks(Schema.ref(:Clock), "Clock entry information", required: true)
          end
        end
    }
  end

  # Documentation pour toutes les actions (index, create, show)
  def paths do
    quote do
      swagger_path :index do
        get("/api/clocks/{user_id}")
        description("Retrieve all clock entries for a user")
        parameter(:user_id, :path, :integer, "User ID", required: true)
        response(200, "OK", Schema.array(:Clock))
      end

      swagger_path :create do
        post("/api/clocks/{user_id}")
        description("Create a new clock entry for a user")
        parameter(:user_id, :path, :integer, "User ID", required: true)

        parameter(:clock, :body, Schema.ref(:CreateClock), "Clock entry to create",
          required: true
        )

        response(201, "Clock created", Schema.ref(:Clock))
      end
    end
  end
end
