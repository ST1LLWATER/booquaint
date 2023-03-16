defmodule Booquaint.Auth.Guardian do
  use Guardian, otp_app: :booquaint

  alias Booquaint.Accounts

  def subject_for_token(%{id: id}, _claims) do
    sub = to_string(id)
    {:ok, sub}
  end

  def subject_for_token(_, _) do
    {:error, :no_id_provided}
  end

  def resource_from_claims(%{"sub" => id}) do
    case Accounts.get_account_by_id(id) do
      nil -> {:error, :not_found}
      account -> {:ok, account}
    end
  end

  def resource_from_claims(_) do
    {:error, :no_id_provided}
  end

  def authenticate(email, password) do
    case Accounts.get_account_by_email(email) do
      nil ->
        {:error, :not_found}

      account ->
        case validate_password(password, account.hashed_password) do
          true -> create_token(account)
          false -> {:error, :invalid_password}
        end
    end
  end

  defp validate_password(password, hashed_password) do
    Pbkdf2.verify_pass(password, hashed_password)
  end

  defp create_token(account) do
    {:ok, token, _claim} = encode_and_sign(account)
    {:ok, account, token}
  end
end
