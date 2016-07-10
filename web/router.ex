defmodule OauthenatorApp.Router do
  use OauthenatorApp.Web, :router
  # TODO: this plug should be renamed / refactored
  import OauthenatorApp.Auth, only: [authenticate_user: 2]

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    # TODO: this plug should be renamed / refactored
    plug OauthenatorApp.Auth, repo: OauthenatorApp.Repo
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :protected do
    # TODO: this plug should be renamed / refactored
    plug :authenticate_user
  end

  scope "/", OauthenatorApp do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/registrations", RegistrationController
    resources "/login", SessionController, only: [:new, :create, :delete]
  end

  scope "/oauth", OauthenatorApp do
    pipe_through :browser # Use the default browser stack
    pipe_through :protected

    get "/authorize", AuthorizationController, :new
    post "/authorize", AuthorizationController, :create
  end

  # Other scopes may use custom stacks.
  # scope "/api", OauthenatorApp do
  #   pipe_through :api
  # end
end
