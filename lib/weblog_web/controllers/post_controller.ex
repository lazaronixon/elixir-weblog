defmodule WeblogWeb.PostController do
  use WeblogWeb, :controller

  alias Weblog.Posts
  alias Weblog.Posts.Post

  plug :set_post when action in [:show, :edit, :update, :delete]

  def index(conn, _params) do
    render conn, :index, posts: Posts.list_posts
  end

  def new(conn, _params) do
    render conn, :new, changeset: Posts.change_post(%Post{})
  end

  def create(conn, %{"post" => post_params}) do
    case Posts.create_post(post_params) do
      {:ok, post} ->
        conn |> put_flash(:info, "Post created successfully.") |> redirect(to: Routes.post_path(conn, :show, post))

      {:error, %Ecto.Changeset{} = changeset} ->
        render conn, :new, changeset: changeset
    end
  end

  def show(conn, _params) do
    render conn, :show
  end

  def edit(conn, _params) do
    render conn, :edit, changeset: Posts.change_post(conn.assigns[:post])
  end

  def update(conn, %{"post" => post_params}) do
    case Posts.update_post(conn.assigns[:post], post_params) do
      {:ok, post} ->
        conn |> put_flash(:info, "Post updated successfully.") |> redirect(to: Routes.post_path(conn, :show, post))

      {:error, %Ecto.Changeset{} = changeset} ->
        render conn, :edit, changeset: changeset
    end
  end

  def delete(conn, _params) do
    Posts.delete_post(conn.assigns[:post])

    conn |> put_flash(:info, "Post deleted successfully.") |> redirect(to: Routes.post_path(conn, :index))
  end

  defp set_post(conn, _params) do
    assign conn, :post, Posts.get_post!(conn.params["id"])
  end
end
