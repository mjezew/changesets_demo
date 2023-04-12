defmodule Changesets.Repo do
  use Ecto.Repo,
    otp_app: :changesets,
    adapter: Ecto.Adapters.Postgres
end
