defmodule WeblogWeb.PageController do
  use WeblogWeb, :controller

  def index(conn, _) do
    render conn, :index
  end
end
