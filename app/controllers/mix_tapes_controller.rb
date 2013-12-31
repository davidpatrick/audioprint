class MixTapesController < ApplicationController
  before_action :set_mix_tape, only: [:show, :edit, :update, :destroy]
  layout "product", only: [:show, :edit, :new]
  load_and_authorize_resource

  def index
    if params[:category]
      @mixtapes = MixTape.without_deleted.where(category_id: params[:category])
    else
      @mixtapes = MixTape.without_deleted
    end

    if params[:search]
      ap, catalog_id = params[:search].upcase.split("AP")

      if catalog_id && is_a_number?(catalog_id)
        @mixtapes = @mixtapes.where(catalog_id: catalog_id)
      else
        @mixtapes = @mixtapes.where("title ILIKE ?", "%#{params[:search]}%")
      end
    end

    @featured_mixtape = MixTape.last
  end

  def show
  end

  def edit
  end

  def new
    @mix_tape = MixTape.new
  end

  def create
    @mix_tape = MixTape.new(params[:mix_tape])
    @mix_tape.user = current_user

    respond_to do |format|
      if @mix_tape.save
        # current_user.add_role :admin, @mix_tape
        format.html { redirect_to edit_mix_tape_path(@mix_tape), notice: 'This album has been created! Now upload some songs! ' }
        format.json { render json: @mix_tape, status: :created, location: @mix_tape }
      else
        format.html { render action: "new" }
        format.json { render json: @mix_tape.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @mix_tape.update_attributes(params[:mix_tape])
        format.html { redirect_to @mix_tape, notice: 'Album was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @mix_tape.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @mix_tape.destroy

    respond_to do |format|
      format.html { redirect_to mix_tapes_url }
      format.json { head :no_content }
    end
  end

  def sort_tracks
    if params[:album_id] && params[:song]
      mix_tape = MixTape.find(params[:album_id])

      params[:song].each_with_index do |id, index|
        mix_tape.track_list.update_all({track: index+1}, {id: id})
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
    album = MixTape.find(params[:id])
    new_song = album.songs.build(mp3: response.request.request_parameters[:qqfile]) if album

    unless new_song.extract_metadata && new_song.save
      file_name = new_song.mp3.to_s
      new_song.title = File.basename(file_name, File.extname(file_name))
      if new_song.mix_tape.songs.empty?
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mix_tape
      @mix_tape = MixTape.without_deleted.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    # def mix_tape_params
    #   params.require(:mix_tape).permit(:title, :catalog_id, :price, :category, :quantity)
    # end
end
