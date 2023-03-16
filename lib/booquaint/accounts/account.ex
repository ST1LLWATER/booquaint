defmodule Booquaint.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  @derive {Jason.Encoder, only: [:email]}
  schema "accounts" do
    field :email, :string
    field :password, :string, virtual: true
    field :hashed_password, :string

    timestamps()
  end

  def registration_changeset(account, attrs) do
    account
    |> cast(attrs, [:email, :password])
    |> validate_email()
    |> validate_password()
  end

  defp validate_email(changeset) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "Enter a valid email")
    |> validate_length(:email, max: 160)
    |> validate_unique_email()
  end

  defp validate_password(changeset) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password,
      min: 4,
      max: 72,
      message: "Password must be at least 4 characters"
    )
    |> hash_password()
  end

  defp hash_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        changeset
        |> put_change(:hashed_password, Pbkdf2.hash_pwd_salt(pass))
        |> delete_change(:password)

      _ ->
        changeset
    end
  end

  defp validate_unique_email(changeset) do
    changeset
    |> unsafe_validate_unique(:email, Booquaint.Repo, message: "Email is already taken")
    |> unique_constraint(:email, message: "Email already taken")
  end

  def email_changeset(account, attrs) do
    account
    |> cast(attrs, [:email])
    |> validate_email()
    |> case do
      %{changes: %{email: _}} = changeset -> changeset
      %{} = changeset -> add_error(changeset, :email, "did not change")
    end
  end

  @doc """
  A account changeset for changing the password.
  
  ## Options
  
    * `:hash_password` - Hashes the password so it can be stored securely
      in the database and ensures the password field is cleared to prevent
      leaks in the logs. If password hashing is not needed and clearing the
      password field is not desired (like when using this changeset for
      validations on a LiveView form), this option can be set to `false`.
      Defaults to `true`.
  """
  def password_changeset(account, attrs) do
    account
    |> cast(attrs, [:password])
    |> validate_confirmation(:password, message: "does not match password")
    |> validate_password()
  end

  @doc """
  Confirms the account by setting `confirmed_at`.
  """
  def confirm_changeset(account) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    change(account, confirmed_at: now)
  end

  @doc """
  Verifies the password.
  
  If there is no account or the account doesn't have a password, we call
  `Pbkdf2.no_user_verify/0` to avoid timing attacks.
  """
  def valid_password?(%Booquaint.Accounts.Account{hashed_password: hashed_password}, password)
      when is_binary(hashed_password) and byte_size(password) > 0 do
    Pbkdf2.verify_pass(password, hashed_password)
  end

  def valid_password?(_, _) do
    Pbkdf2.no_user_verify()
    false
  end

  @doc """
  Validates the current password otherwise adds an error to the changeset.
  """
  def validate_current_password(changeset, password) do
    if valid_password?(changeset.data, password) do
      changeset
    else
      add_error(changeset, :current_password, "is not valid")
    end
  end
end
