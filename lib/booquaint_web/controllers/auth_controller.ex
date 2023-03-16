defmodule BooquaintWeb.AuthController do
  use BooquaintWeb, :controller

  alias Booquaint.{Accounts, Auth.Guardian, Accounts.Account}

  def create(conn, params) do
    case Accounts.create_account(params) do
      {:ok, %Account{} = account} ->
        conn
        |> put_session(:account, account)
        |> json(%{
          success: true,
          message: "Account created successfully",
          account: account
        })

      {:error, changeset} ->
        errors = changeset.errors |> Map.new()

        err_messages = Map.new(errors, fn {key, {message, _something}} -> {key, message} end)

        conn
        |> put_status(400)
        |> json(%{
          success: false,
          message: "Account could not be created",
          errors: err_messages
        })
    end
  end

  def test(conn, _params) do
    data = get_session(conn, :account)

    conn
    |> put_status(200)
    |> json(%{
      success: true,
      message: "Test successful",
      data: data
    })
  end
end
