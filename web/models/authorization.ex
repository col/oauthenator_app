defmodule OauthenatorApp.Authorization do
  use OauthenatorApp.Web, :model

  embedded_schema do
    field :client_id
    field :redirect_url
    field :type
    field :state
    field :scope
  end

  @required_fields ~w(client_id redirect_url type)
  @optional_fields ~w(state scope)

  def changeset(model, params \\ :empty) do
    model |> cast(params, @required_fields, @optional_fields)
  end

end
