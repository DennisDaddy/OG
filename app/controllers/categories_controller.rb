class CategoriesController < ApplicationController
   before_action :require_admin, except: [:index, :show]
  def index
    @categories = Category.all
  end

  def new
    @category = Category.new    
  end

  def create
    @category = Category.new(category_params)
    if @category.save     
      flash[:success] = "Category successfuly Created"
      redirect_to categories_path
    else
      flash[:danger] = "Failed or login as admin to continue!"
      redirect_to new_category_path
    end    
  end

  def show
    @category = Category.find(params[:id])
    @title = @category.name
    @posts = @category.posts
  end

  def edit
     @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update_attributes(category_params)
      flash[:success] = "Category successfuly updated!!"    
    redirect_to categories_path
    else
      render 'edit'
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    flash[:success] = "Category successfuly deleted!!"
    redirect_to request.referrer || root_url
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end

  def require_admin
    if !logged_in? || (logged_in? and !current_user.admin?)
        flash[:danger] = "Only admins can perform this action"
        redirect_to categories_path
      end
    end
end