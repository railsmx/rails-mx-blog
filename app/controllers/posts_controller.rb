class PostsController < ApplicationController
  def index
    @posts   = Post.for_index
    @history = Post.for_history - @posts
  end

  def show
    @post = Post.find_by_permalink(params[:id])
    unless @post
      @post = Post.find(params[:id])
      @post.published_at = Date.today
    end
    @history = Post.for_history - [@post]
  end
end
