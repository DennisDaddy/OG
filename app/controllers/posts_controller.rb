class PostsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create,:edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update, :destroy]
  def index
    @posts = Post.paginate(page: params[:page])
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = "Post successfuly created!"
      redirect_to root_url
    else
      flash[:danger] = "Post not created fill all fields!"
      redirect_to request.referrer || root_url
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(post_params)
      flash[:success] = "Post successfully updated!"
      redirect_to @post
    else
      render 'edit'
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def destroy
    @post.destroy
    flash[:success] = "Post successfully deleted"
    redirect_to @post
  end

  private
  def post_params
    params.require(:post).permit(:title, :content, :category_id)
  end

  def correct_user
    @post = current_user.posts.find_by(id: params[:id])
    redirect_to root_url if @post.nil?
  end
end