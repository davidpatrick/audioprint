class SongsController < ApplicationController
  load_and_authorize_resource

  # SEND_FILE_METHOD = :default
  # GET /songs
  # GET /songs.json
  def index
    unless current_user && current_user.has_role?(:administrator)
      redirect_to '/'
      return
    end

    @songs = Song.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @songs }
    end
  end

  # GET /songs/1
  # GET /songs/1.json
  def show
    @song = Song.find(params[:id])
    render :file => 'public/404.html', :layout => false and return unless @song

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @song }
    end
  end

  def new
    if !params[:album] || request.referer.nil?
      redirect_to root_path
      return
    elsif URI(request.referer).path != "/albums/#{params[:album]}/edit"
      redirect_to root_path
      return
    end

    @song = Song.new

    respond_to do |format|
      format.html { render :layout => false }
      format.json { render json: @song }
    end
  end

  def edit
    if request.referer.nil?
      redirect_to root_path
      return
    elsif URI(request.referer).path != "/albums/#{@song.album.id}/edit"
      redirect_to root_path
      return
    end

    @song = Song.find(params[:id])
    render :file => 'public/404.html', :layout => false and return unless @song

    respond_to do |format|
      format.html { render :layout => false }
      format.json { render json: @song }
    end
  end

  def create
    @song = Song.new(params[:song])

    if @song.album
      if @song.album.track_list.empty?
        @song.track ||= 1
      else
        @song.track ||= @song.album.track_list.last.track + 1
      end
    end

    respond_to do |format|
      if @song.save
        # format.json { render json: @song, status: :created, location: @song }
        format.js { render :template => 'albums/ajax_song', :locals => { :song => @song } }
        format.html { redirect_to @song.album, notice: 'Song was successfully created.' }
      else
        format.js { render :template => 'albums/ajax_song', :locals => { :song => @song } }
        format.html { render action: "new" }
      end
    end
  end

  # PUT /songs/1
  # PUT /songs/1.json
  def update
    @song = Song.find(params[:id])
    render :file => 'public/404.html', :layout => false and return unless @song

    respond_to do |format|
      if @song.update_attributes(params[:song])
        format.html { redirect_to edit_album_path(@song.album), notice: 'Song was successfully updated.' }
        format.json { head :no_content }
        format.js { render :template => 'songs/update_song', :locals => { :song => @song } }
      else
        format.html { render action: "edit" }
        format.json { render json: @song.errors, status: :unprocessable_entity }
        format.js { render :template => 'songs/update_song', :locals => { :song => @song } }
      end
    end
  end

  # DELETE /songs/1
  # DELETE /songs/1.json
  def destroy
    @song = Song.find(params[:id])
    @song.destroy

    respond_to do |format|
      format.html { redirect_to songs_url }
      format.json { head :no_content }
    end
  end

  def download
    render :status => :forbidden, :text => "Nothing here." and return unless song = Song.find_by_id(params[:id])
    render :status => :forbidden, :text => "Forbidden fruit" and return unless song.downloadable?(current_user)

    path = song.mp3.path(params[:style])
    head(:bad_request) and return unless params[:format].to_s == File.extname(path).gsub(/^\.+/, '')

    song.downloads += 1
    if song.save
      redirect_to(song.download_url)
    end
    # send_file_options = { :type => MIME::Types.type_for(path).first.content_type }

    # case SEND_FILE_METHOD
    #   when :apache then send_file_options[:x_sendfile] = true
    #   when :nginx then head(:x_accel_redirect => path.gsub(Rails.root, ''), :content_type => send_file_options[:type]) and return
    # end

    # send_file(path, send_file_options)
  end
end
