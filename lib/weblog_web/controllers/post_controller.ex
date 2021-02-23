defmodule WeblogWeb.PostController do
  use WeblogWeb, :controller

  alias Weblog.Posts
  alias Weblog.Posts.Post

  plug :set_post when action in [:show, :edit, :update, :delete]

  def index(conn, _) do
    render conn, :index, posts: Posts.list_posts
  end

  def show(conn, _) do
    render conn, :show
  end

  def new(conn, _) do
    render conn, :new, changeset: Posts.change_post(%Post{})
  end

  def edit(conn, _) do
    render conn, :edit, changeset: Posts.change_post(conn.assigns[:post])
  end

  def create(conn, %{"post" => post_params}) do
    case Posts.create_post(post_params) do
      {:ok, post} ->
        case get_format(conn) do
          "html" -> conn |> put_flash(:info, "Post created successfully.") |> redirect(to: Routes.post_path(conn, :show, post))
          "json" -> conn |> put_status(:created) |> put_resp_header("location", Routes.post_path(conn, :show, post)) |> render(:show, post: post)
        end

      {:error, %Ecto.Changeset{} = changeset} ->
        case get_format(conn) do
          "html" -> conn |> render(:new, changeset: changeset)
          "json" -> conn |> put_status(:unprocessable_entity) |> render(WeblogWeb.ErrorView, "error.json", changeset: changeset)
        end
    end
  end

  def update(conn, %{"post" => post_params}) do
    case Posts.update_post(conn.assigns[:post], post_params) do
      {:ok, post} ->
        case get_format(conn) do
          "html" -> conn |> put_flash(:info, "Post updated successfully.") |> redirect(to: Routes.post_path(conn, :show, post))
          "json" -> conn |> put_status(:ok) |> put_resp_header("location", Routes.post_path(conn, :show, post)) |> render(:show, post: post)
        end

      {:error, %Ecto.Changeset{} = changeset} ->
        case get_format(conn) do
          "html" -> conn |> render(:edit, changeset: changeset)
          "json" -> conn |> put_status(:unprocessable_entity) |> render(WeblogWeb.ErrorView, "error.json", changeset: changeset)
        end
    end
  end

  def delete(conn, _) do
    Posts.delete_post(conn.assigns[:post])

    case get_format(conn) do
      "html" -> conn |> put_flash(:info, "Post deleted successfully.") |> redirect(to: Routes.post_path(conn, :index))
      "json" -> send_resp conn, :no_content, ""
    end
  end

  defp set_post(conn, _) do
    assign conn, :post, Posts.get_post!(conn.params["id"])
  end
end
