defmodule Booquaint.Accounts do
  alias Booquaint.Accounts.Account
  alias Booquaint.Repo

  def create_account(attrs) do
    %Account{}
    |> Account.registration_changeset(attrs)
    |> Repo.insert()
  end

  def get_account_by_id(id) do
    Repo.get(Account, id)
  end

  def get_account_by_email(email) do
    Repo.get_by(Account, email: email)
  end
end
