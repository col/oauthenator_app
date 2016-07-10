defmodule OauthenatorApp.AuthorizationController do
  use OauthenatorApp.Web, :controller
  alias OauthenatorApp.Authorization

  plug AuthorizePlug, only: [:index]

  def new(conn, params) do
    render conn, "index.html",
      oauth_client: Map.get(conn.assigns, :oauth_client),
      authorization: conn.assigns.authorization
  end

  def create(conn, params) do
    authorization = conn.assigns.authorization
    # TODO: do more stuff here!
    redirect(conn, external: "http://www.google.com")
  end
end
