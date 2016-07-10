defmodule AuthorizePlug do
  import Plug.Conn
  use Oauthenator

  def init(opts) do
    opts
  end

  def call(conn, _) do
    case Repo.get_by(OauthClient, random_id: conn.params["client_id"]) do
      nil ->
        conn |> send_resp(404, "Client not found") |> halt
      client ->
        conn |> assign(:oauth_client, client)
    end
  end

end
