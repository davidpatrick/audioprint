class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    authorize! :admin, User, :message => 'You need to be an administrator to do that.'
    @users = User.all
  end

  def new
    authorize! :admin, User, :message => 'You need to be an administrator to do that.'
    @user = User.new

    render :layout => 'product'
  end

  def edit_role
    @user = User.find(params[:id])
    authorize! :admin, @user, :message => 'You need to be an administrator to do that.'

    render :layout => false
  end

  def change_role
    @user = User.find(params[:id])
    authorize! :admin, @user, :message => 'You need to be an administrator to do that.'

    if Role.role_types.include? params[:user][:role_ids]
      Role.role_types.each{ |role| @user.remove_role role}
      @role = @user.add_role params[:user][:role_ids]
    end

    render :template => 'users/change_role.js.erb'
  end

  def create
    authorize! :admin, User, :message => 'You need to be an administrator to do that.'
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        format.html { redirect_to users_path, notice: 'This user has been created! ' }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @user = User.find(params[:id])
    authorize! :admin, @user, :message => 'You need to be an administrator to do that.'

    @albums = @user.albums
    @songs = @user.songs.order('downloads DESC')
  end

  def update
    @user = User.find(params[:id])
    authorize! :update, @user, :message => 'Not authorized as an administrator.'

    if @user.update_attributes(params[:user], :as => :admin)
      redirect_to users_path, :notice => "User updated."
    else
      redirect_to users_path, :alert => "Unable to update user."
    end
  end

  def destroy
    @user = User.find(params[:id])
    authorize! :destroy, @user, :message => 'Not authorized as an administrator.'

    unless @user == current_user
      @user.destroy
      redirect_to users_path, :notice => "User deleted."
    else
      redirect_to users_path, :notice => "Can't delete yourself."
    end
  end

  # def become_contributor
  #   unless current_user.account_request == 3
  #     UserMailer.request_account(current_user, 'Contributor').deliver if current_user.update_attribute(:account_request, 3)
  #     redirect_to edit_user_registration_path, :notice => "Request has been sent."
  #   else
  #     redirect_to edit_user_registration_path, :notice => "You have already sent this request."
  #   end
  # end
end