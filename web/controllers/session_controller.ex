defmodule OauthenatorApp.SessionController do
  use OauthenatorApp.Web, :controller

  def new(conn, _) do
    render conn, "new.html"
  end

  def create(conn, %{"session" => %{"email" => email, "password" => pass}}) do
    case OauthenatorApp.Auth.login_by_email_and_pass(conn, email, pass, repo: Repo) do
      {:ok, conn} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> redirect(external: after_login_url(conn))
      {:error, _reason, conn} ->
        conn
        |> put_flash(:error, "Invalid email/password combination") |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> OauthenatorApp.Auth.logout()
    |> redirect(to: page_path(conn, :index))
  end

  defp after_login_url(conn) do
    case get_session(conn, :requested_url) do
      nil ->
        page_url(conn, :index)
      url ->
        IO.puts "Redirecting to #{url}"
        put_session(conn, :requested_url, nil)
        url
    end
  end

end
