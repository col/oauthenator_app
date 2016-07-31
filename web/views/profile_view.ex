defmodule OauthenatorApp.ProfileView do
  use OauthenatorApp.Web, :view

  def render("show.json", %{user: user}) do
    user
  end

end
