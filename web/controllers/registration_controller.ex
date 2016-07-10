defmodule OauthenatorApp.RegistrationController do
  use OauthenatorApp.Web, :controller
  alias OauthenatorApp.User

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => registration_params}) do
    changeset = User.registration_changeset(%User{}, registration_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "You have registered successfully.")
        |> render("show.html", registration: user)
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    registration = Repo.get!(User, id)
    render(conn, "show.html", registration: registration)
  end

end
