defmodule AuthorizePlug do
  use Plug.Builder, log_on_halt: :debug
  use Oauthenator
  import Plug.Conn
  alias OauthenatorApp.Authorization

  plug :check_params
  plug :check_client

  def init(opts) do
    opts
  end

  def check_client(conn, _) do
    authorization = conn.assigns.authorization
    case Repo.get_by(OauthClient, random_id: authorization.client_id) do
      nil ->
        conn |> send_resp(404, "Client not found") |> halt
      client ->
        conn |> assign(:oauth_client, client)
    end
  end

  def check_params(conn, _opts) do
    authorization = Authorization.new(auth_params(conn))
    case Authorization.valid?(authorization) do
      :ok ->
        assign(conn, :authorization, authorization)
      {:error, errors} ->
        IO.puts "Invalid request: #{inspect(errors)}"
        conn |> send_resp(400, "Invalid request") |> halt
    end
  end

  def auth_params(%{params: %{"authorization" => params}}), do: params
  def auth_params(%{params: params}), do: params

end
