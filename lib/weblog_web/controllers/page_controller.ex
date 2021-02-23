defmodule WeblogWeb.PageController do
  use WeblogWeb, :controller

  def index(conn, _params) do
    render conn, :index
  end
end
