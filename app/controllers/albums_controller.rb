class AlbumsController < ApplicationController
  load_and_authorize_resource
  layout "product", only: [:show, :edit, :new]

  def index
    if params[:category]
      @albums = Album.without_deleted.where(category_id: params[:category])
    else
      @albums = Album.without_deleted.scoped
    end

    if params[:search]
      ap, catalog_id = params[:search].upcase.split("AP")

      if catalog_id && is_a_number?(catalog_id)
        @albums = @albums.where(catalog_id: catalog_id)
      else
        @albums = @albums.where("title || artist ILIKE ?", "%#{params[:search]}%")
      end
    end

    @featured_album = Album.last
  end

  def show
    @album = Album.without_deleted.find_by_id(params[:id])
    render :file => 'public/404.html', :layout => false unless @album
  end

  def edit
    @album = Album.without_deleted.find_by_id(params[:id])
    render :file => 'public/404.html', :layout => false and return unless @album
  end

  def new
    @album = Album.new
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
        format.html { redirect_to @album, notice: 'Album was successfully updated.' }
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

      respond_to do |format|
        format.json { head :ok }
      end
    else
      respond_to do |format|
        format.json { render :status => :unprocessable_entity }
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
