defmodule OauthenatorApp.Router do
  use OauthenatorApp.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", OauthenatorApp do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/registrations", RegistrationController
  end

  # Other scopes may use custom stacks.
  # scope "/api", OauthenatorApp do
  #   pipe_through :api
  # end
end
