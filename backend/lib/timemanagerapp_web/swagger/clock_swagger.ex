defmodule TimeManagerAppWeb.Swagger.ClockSwagger do
  use PhoenixSwagger

  def swagger_definitions do
    %{
      Clock:
        swagger_schema do
          title("Clock")
          description("A clock record for a user")

          properties do
            id(:integer, "Clock ID", required: true)
            user_id(:integer, "User ID associated with the clock", required: true)
            time(:string, "Time the clock was recorded", required: true)
            status(:boolean, "Status of the clock", required: true)
          end
        end,
      CreateClock:
        swagger_schema do
          title("CreateClock")
          description("Schema for creating a clock")

          properties do
            clock(Schema.ref(:Clock), "Clock information", required: true)
          end
        end
    }
  end

  def paths do
    quote do
      swagger_path :index do
        description("Retrieve a list of clocks for a user.")
        parameter(:user_id, :path, :integer, "User ID", required: true)
        response(200, "OK", Schema.ref(:Clock))
      end

      swagger_path :create do
        description("Create a new clock for a user.")
        parameter(:user_id, :path, :integer, "User ID", required: true)

        parameter(:clock, :body, Schema.ref(:CreateClock), "The clock information to create",
          required: true
        )

        response(201, "Clock created", Schema.ref(:Clock))
      end

      swagger_path :show do
        description("Retrieve a clock by ID for a user.")
        parameter(:user_id, :path, :integer, "User ID", required: true)
        parameter(:id, :path, :integer, "Clock ID", required: true)
        response(200, "Clock found", Schema.ref(:Clock))
        response(404, "Clock not found")
      end
    end
  end
end
