defmodule Booquaint.Repo do
  use Ecto.Repo,
    otp_app: :booquaint,
    adapter: Ecto.Adapters.Postgres
end
