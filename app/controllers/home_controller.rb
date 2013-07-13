class HomeController < ApplicationController
  def index
    redirect_to blog_posts_path
    return

    @featured_blogs = BlogPost.all.reverse!

    respond_to do |format|
      format.html { render :layout => 'home' }
      # format.json { render json: @album }
    end
  end

  def landing
    respond_to do |format|
      format.html { render :layout => 'landing' }
      # format.json { render json: @album }
    end
  end
end
