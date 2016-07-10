defmodule OauthenatorApp.Authorization do
  use OauthenatorApp.Web, :model
  alias OauthenatorApp.Authorization

  embedded_schema do
    field :client_id
    field :redirect_url
    field :response_type
    field :state
    field :scope
  end

  @required_fields ~w(client_id response_type)
  @optional_fields ~w(redirect_url state scope)

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

end
