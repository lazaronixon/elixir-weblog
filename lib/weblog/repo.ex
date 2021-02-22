defmodule Weblog.Repo do
  use Ecto.Repo,
    otp_app: :weblog,
    adapter: Ecto.Adapters.Postgres
end
