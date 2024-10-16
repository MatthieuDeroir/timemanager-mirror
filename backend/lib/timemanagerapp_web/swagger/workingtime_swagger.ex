defmodule TimeManagerAppWeb.Swagger.WorkingTimeSwagger do
  use PhoenixSwagger

  # Swagger schema definitions for the WorkingTime entity
  def swagger_definitions do
    %{
      WorkingTime:
        swagger_schema do
          title("WorkingTime")
          description("A working time of a user")

          properties do
            id(:integer, "Working time ID", required: true)
            start_time(:string, "Start time", format: :date_time, required: true)
            end_time(:string, "End time", format: :date_time, required: true)
            user_id(:integer, "User ID", required: true)
          end
        end,
      CreateWorkingTime:
        swagger_schema do
          title("CreateWorkingTime")
          description("Schema for creating a working time")

          properties do
            workingtime(Schema.ref(:WorkingTime), "Working time information", required: true)
          end
        end,
      UpdateWorkingTime:
        swagger_schema do
          title("UpdateWorkingTime")
          description("Schema for updating a working time")

          properties do
            workingtime(Schema.ref(:WorkingTime), "Working time information", required: true)
          end
        end
    }
  end

  # Documentation for all actions (index, create, show, update, delete)
  def paths do
    quote do
      swagger_path :index do
        description("Retrieve all working times for a user.")
        parameter(:user_id, :path, :integer, "User ID", required: true)
        response(200, "OK", Schema.ref(:WorkingTime))
      end

      swagger_path :create do
        description("Create a new working time.")

        parameter(
          :workingtime,
          :body,
          Schema.ref(:CreateWorkingTime),
          "The working time information to create",
          required: true
        )

        response(201, "Working time created", Schema.ref(:WorkingTime))
      end

      swagger_path :show do
        description("Retrieve a working time by ID.")
        parameter(:user_id, :path, :integer, "User ID", required: true)
        parameter(:id, :path, :integer, "Working time ID", required: true)
        response(200, "Working time found", Schema.ref(:WorkingTime))
        response(404, "Working time not found")
      end

      swagger_path :update do
        description("Update an existing working time.")
        parameter(:id, :path, :integer, "Working time ID", required: true)

        parameter(
          :workingtime,
          :body,
          Schema.ref(:UpdateWorkingTime),
          "The working time information to update",
          required: true
        )

        response(200, "Working time updated", Schema.ref(:WorkingTime))
      end

      swagger_path :delete do
        description("Delete a working time.")
        parameter(:id, :path, :integer, "Working time ID", required: true)
        response(204, "Working time deleted")
      end
    end
  end
end
