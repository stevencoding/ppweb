class BlogsController < ApplicationController
  before_filter :check_admin, :except => [:index, :show]
  def index
    @blogs = Blog.recent
  end

  def new
    @blog = Blog.new
  end

  def edit
    @blog = Blog.find(params[:id])
  end

  def show
    @blog = Blog.find(params[:id])
  end

  def update
    blog = Blog.find(params[:id])
    blog.update_attributes(params[:blog])
    title = params[:blog][:title]
    name = PinYin.of_string(title).join('-').downcase
    blog.name = name
    blog.save!
    redirect_to blog_path(blog), :notice => "blog updated"
  end

  def create
    blog = Blog.new(params[:blog])
    title = params[:blog][:title]
    name = PinYin.of_string(title).join('-').downcase
    blog.user_id = current_user.id
    blog.name = name
    if blog.save
      redirect_to blog_path(blog), :notice => "blog was born!"
    else
      render "new"
    end
  end
end
