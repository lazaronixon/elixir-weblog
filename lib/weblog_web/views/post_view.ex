defmodule WeblogWeb.PostView do
  use WeblogWeb, :view

  def render("index.json", %{posts: posts}) do
    render_many(posts, WeblogWeb.PostView, "post.json")
  end

  def render("show.json", %{post: post}) do
    render_one(post, WeblogWeb.PostView, "post.json")
  end

  def render("post.json", %{post: post}) do
    %{title: post.title, body: post.body}
  end
end
