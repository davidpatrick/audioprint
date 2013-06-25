class UsersController < ApplicationController
  before_filter :authenticate_user!

  def index
    authorize! :manage, @user, :message => 'You need to be an administrator to do that.'
    @users = User.all
  end

  def show
    if current_user && current_user.id.to_s == params[:id]
      authorize! :manage, @user, :message => 'You need to be an administrator to do that.'
    else
      authorize! :manage, @user, :message => 'You need to be an administrator to do that.'
    end

    @user = User.find(params[:id])
    @albums = @user.albums
    @songs = @user.songs.order('downloads DESC')
  end

  def update
    authorize! :update, @user, :message => 'Not authorized as an administrator.'
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user], :as => :admin)
      redirect_to users_path, :notice => "User updated."
    else
      redirect_to users_path, :alert => "Unable to update user."
    end
  end

  def destroy
    authorize! :destroy, @user, :message => 'Not authorized as an administrator.'
    user = User.find(params[:id])
    unless user == current_user
      user.destroy
      redirect_to users_path, :notice => "User deleted."
    else
      redirect_to users_path, :notice => "Can't delete yourself."
    end
  end

  def become_contributor
    unless current_user.account_request == 3
      UserMailer.request_account(current_user, 'Contributor').deliver if current_user.update_attribute(:account_request, 3)
      redirect_to edit_user_registration_path, :notice => "Request has been sent."
    else
      redirect_to edit_user_registration_path, :notice => "You have already sent this request."
    end
  end
end