defmodule FabricEx.Repo do
  use Ecto.Repo,
    otp_app: :fabric_ex,
    adapter: Ecto.Adapters.Postgres
end
