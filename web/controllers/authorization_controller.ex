defmodule OauthenatorApp.AuthorizationController do
  use OauthenatorApp.Web, :controller
  alias OauthenatorApp.Authorization

  plug AuthorizePlug, only: [:index]

  def new(conn, params) do
    oauth_client = Map.get(conn.assigns, :oauth_client)
    changeset = Authorization.changeset(%Authorization{}, %{
      client_id: params["client_id"],
      redirect_url: params["redirect_uri"],
      type: params["type"],
      status: params["status"],
      scope: params["scope"]
    })
    render conn, "index.html", oauth_client: oauth_client, changeset: changeset
  end

  def create(conn, params) do
    changeset = Authorization.changeset(%Authorization{}, %{
      client_id: params.client_id,
      redirect_url: params.redirect_url,
      type: params.type,
      status: params.status,
      scope: params.scope
    })
    # TODO: do more stuff here!
    redirect(conn, external: "http://www.google.com")
  end
end
