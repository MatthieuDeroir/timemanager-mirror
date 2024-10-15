# Stage 1: Build the application
FROM elixir:1.14-alpine AS build

# Install build dependencies
RUN apk add --no-cache build-base git nodejs npm

# Set working directory
WORKDIR /app

# Copy mix files and install Hex and Rebar
COPY mix.exs mix.lock ./
RUN mix local.hex --force && mix local.rebar --force

# Install dependencies
RUN mix deps.get --only prod

# Copy the rest of the application code
COPY . .

# Compile the application
RUN MIX_ENV=prod mix compile

# Generate static assets digest
RUN MIX_ENV=prod mix phx.digest

# Build the release
RUN MIX_ENV=prod mix release --overwrite

# Stage 2: Run the application
FROM alpine:3.17 AS runtime

# Install runtime dependencies including CA certificates
RUN apk add --no-cache libstdc++ openssl ncurses-libs ca-certificates

# Update CA certificates
RUN update-ca-certificates

# Set working directory
WORKDIR /app

# Copy the release from the build stage
COPY --from=build /app/_build/prod/rel/timemanagerapp ./

# Set environment variables
ENV HOME=/app
ENV MIX_ENV=prod

# Expose the port your application runs on
EXPOSE 4000

# Start the application
CMD ["bin/timemanagerapp", "start"]
