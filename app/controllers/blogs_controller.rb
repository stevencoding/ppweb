class BlogsController < ApplicationController
  def index
    @blogs = Blog.recent
  end

  def new
    @blog = Blog.new
  end

  def show
    @blog = Blog.find(params[:id])
  end

  def create
    blog = Blog.new(params[:blog])
    title = params[:blog][:title]
    name = PinYin.of_string(title).join('-').downcase
    # blog.user_id = current_user.id
    blog.user_id = User.find_by_username('happypeter').id
    blog.name = name
    if blog.save
      redirect_to blog_path(blog), :notice => "blog was born!"
    else
      render "new"
    end
  end
end
