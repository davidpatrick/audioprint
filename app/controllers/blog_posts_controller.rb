class BlogPostsController < ApplicationController
  load_and_authorize_resource

  def index
    @blog_posts = BlogPost.all.order("created_at DESC")
  end

  def show
    if params[:slug]
      @blog_post = BlogPost.find_by_slug(params[:slug])
    else
      redirect_to blog_posts_path(year: params[:id]) and return
    end

    respond_to do |format|
      format.html { render :layout => 'product' }
      format.json { render json: @blog_post }
    end
  end

  def new
    @blog_post = BlogPost.new

    respond_to do |format|
      format.html { render :layout => 'product' }
      format.json { render json: @blog_post }
    end
  end

  def edit
    @blog_post = BlogPost.find_by_slug(params[:slug])
    render :layout => 'product'
  end

  def create
    @blog_post = BlogPost.new(params[:blog_post])

    respond_to do |format|
      if @blog_post.save
        format.html { redirect_to @blog_post, notice: 'Blog post was successfully created.' }
        format.json { render json: @blog_post, status: :created, location: @blog_post }
      else
        format.html { render action: "new" }
        format.json { render json: @blog_post.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @blog_post = BlogPost.find_by_slug(params[:slug])

    respond_to do |format|
      if @blog_post.update_attributes(params[:blog_post])
        format.html { redirect_to edit_blog_post_path(@blog_post), notice: 'Blog post was successfully updated.' }
      else
        format.html { render action: "edit" }
      end
    end
  end

  def destroy
    @blog_post = BlogPost.find_by_slug(params[:slug])
    @blog_post.destroy

    respond_to do |format|
      format.html { redirect_to @blog_post }
      format.json { head :no_content }
    end
  end
end
