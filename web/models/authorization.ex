defmodule OauthenatorApp.Authorization do
  use OauthenatorApp.Web, :model
  alias OauthenatorApp.Authorization

  # embedded_schema do
  #   field :client_id
  #   field :redirect_url
  #   field :response_type
  #   field :state
  #   field :scope
  # end

  defstruct [:client_id, :redirect_url, :response_type, :state, :scope]
  @types %{client_id: :string, redirect_url: :string, response_type: :string, state: :string, scope: :string}

  @required_fields ~w(client_id response_type)
  @optional_fields ~w(redirect_url state scope)

  # def changeset(model, params \\ :empty) do
  #   model
  #   |> {@types}
  #   |> cast(params, @required_fields, @optional_fields)
  # end

  def new(params) do
    # Map.merge(%Authorization{}, params)
    %Authorization{
      client_id: Map.get(params, "client_id"),
      redirect_url: Map.get(params, "redirect_url"),
      response_type: Map.get(params, "response_type"),
      state: Map.get(params, "state"),
      scope: Map.get(params, "scope")
    }
  end

  def valid?(authorization) do
    changeset =
      {authorization, @types}
      |> cast(%{}, @required_fields, @optional_fields)
    case changeset.valid? do
      true -> :ok
      false -> {:error, changeset.errors}
    end
  end
end
