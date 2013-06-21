class AlbumsController < ApplicationController
  load_and_authorize_resource

  def index
    @albums = Album.all
    @featured_albums = Album.first(4)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @albums }
    end
  end

  def show
    @album = Album.find(params[:id])

    respond_to do |format|
      format.html { render :layout => 'product' }
      format.json { render json: @album }
    end
  end

  def edit
    @album = Album.find(params[:id])
    render :layout => 'product'
  end

  def new
    @album = Album.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @album }
    end
  end

  def create
    @album = Album.new(params[:album])
    @album.user = current_user

    respond_to do |format|
      if @album.save
        # current_user.add_role :admin, @album
        format.html { redirect_to edit_album_path(@album), notice: 'This album has been created! Now upload some songs! ' }
        format.json { render json: @album, status: :created, location: @album }
      else
        format.html { render action: "new" }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @album = Album.find(params[:id])

    respond_to do |format|
      if @album.update_attributes(params[:album])
        format.html { redirect_to edit_album_path(@album), notice: 'Album was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @album = Album.find(params[:id])
    @album.destroy

    respond_to do |format|
      format.html { redirect_to albums_url }
      format.json { head :no_content }
    end
  end

  def sort_tracks
    if params[:album_id] && params[:song]
      album = Album.find(params[:album_id])

      params[:song].each_with_index do |id, index|
        album.track_list.update_all({track: index+1}, {id: id})
      end
    end
  end

  def add_songs
    album = Album.find(params[:id])
    new_song = album.songs.build(mp3: response.request.request_parameters[:qqfile]) if album

    unless new_song.extract_metadata && new_song.save
      file_name = new_song.mp3.to_s
      new_song.title = File.basename(file_name, File.extname(file_name))
      new_song.artist = new_song.album.artist
      if new_song.album.songs.empty?
        new_song.track = 1
      else
        new_song.track = new_song.album.songs.order('track').last.track += 1
      end
    end

    if new_song.save
      render :text => '{"success":true, "id":' + new_song.id.to_s + ', "upload_type":"' + new_song.class.to_s + '"}'
    else
      render :text => '{"error":"failed to upload one or more songs"}'
    end
  end

  def ajax_uploaded_song
    ajax_song = Song.find(params[:song])

    if ajax_song
      respond_to do |format|
        format.js { render :template => 'albums/ajax_song', :locals => { :song => ajax_song } }
      end
    else
      return false
    end
  end
end
