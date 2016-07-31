defmodule OauthenatorApp.AccessTokenView do
  use OauthenatorApp.Web, :view

  def render("show.json", %{token: token}) do
    IO.puts "AccessTokenView - render.show.json"
    token
  end

  def render("show.json", %{error: error}) do
    IO.puts "AccessTokenView - render.show.json - Error"
    error
  end
end
