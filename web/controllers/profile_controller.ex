defmodule OauthenatorApp.ProfileController do
  use OauthenatorApp.Web, :controller
  alias OauthenatorApp.{Repo, User}

  def show(conn, %{"id" => id} = params) do
    IO.puts "ProfileController.show Params = #{inspect params}"
    user = Repo.get(User, id)
    render conn, :show, user: user
  end

  def show(conn, params) do
    IO.puts "ProfileController.show Params = #{inspect params}"
    # TODO: this endpoint is not properly protected via OAuth yet.
    render conn, :show, user: conn.assigns.current_user
  end

  def edit(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user)
    render conn, :edit, user: user, changeset: changeset
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.get(User, id)
    changeset = User.changeset(user, user_params)
    case Repo.update(changeset) do
      {:ok, user} ->
        IO.puts "User: #{inspect user}"
        IO.puts "Changeset: #{inspect changeset}"
        redirect(conn, to: profile_path(conn, :show, user))
      {:error, changeset} ->
        render conn, :edit, user: user, changeset: changeset
    end
  end
end
