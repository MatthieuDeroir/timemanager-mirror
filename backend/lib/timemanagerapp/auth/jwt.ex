defmodule TimeManagerApp.Auth.JWT do
  use Joken.Config

  @secret_key System.get_env("JWT_SECRET") || raise("JWT_SECRET environment variable not set")
  @signer Joken.Signer.create("HS256", @secret_key)

  @impl true
  def token_config do
    default_claims()
  end

  def generate_token(user_id) do
    csrf_token = :crypto.strong_rand_bytes(32) |> Base.encode64()
    claims = %{"user_id" => user_id, "csrf_token" => csrf_token}

    case generate_and_sign(claims) do
      {:ok, token, _full_claims} ->
        {:ok, token, claims}

      error ->
        error
    end
  end

  def verify_token(token) do
    Joken.verify_and_validate(token_config, token)
  end
end
