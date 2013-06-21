class HomeController < ApplicationController
  def index
    @albums = Album.all
    @featured_blogs = BlogPost.all

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
