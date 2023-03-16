defmodule BooquaintWeb.Router do
  use BooquaintWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  scope "/api", BooquaintWeb do
    pipe_through :api

    post "/register", AuthController, :create
    get "/test", AuthController, :test
  end
end
