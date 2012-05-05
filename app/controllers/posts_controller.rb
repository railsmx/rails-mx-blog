class PostsController < ApplicationController
  def index
    @posts = Post.for_index
    @archive = Post.for_history - @posts
  end
end
