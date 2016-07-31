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
    plug :fetch_session
    plug OauthenatorApp.Secured#, repo: OauthenatorApp.Repo
    plug OauthenatorApp.Auth, repo: OauthenatorApp.Repo
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
    resources "/profile", ProfileController, only: [:show, :edit, :update]
    # get "/user", ProfileController, :show
  end

  scope "/oauth", OauthenatorApp do
    pipe_through :browser
    pipe_through :protected

    get "/authorize", AuthorizationController, :new
    post "/authorize", AuthorizationController, :create
  end

  scope "/oauth", OauthenatorApp do
    pipe_through :api

    post "/access_token", AccessTokenController, :create
  end

  # Other scopes may use custom stacks.
  scope "/api", OauthenatorApp do
    pipe_through :api

    get "/profile", ProfileController, :show
  end
end
