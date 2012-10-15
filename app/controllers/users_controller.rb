class UsersController < ApplicationController
  include SessionsHelper

  before_filter :signed_in_user,  only: [ :index, :edit, :update, :destroy,
                                          :following, :followers ]
  before_filter :not_signed_in_user, only: [ :create, :new ]
  before_filter :correct_user,    only: [ :edit, :update ]
  before_filter :admin_user,      only: :destroy

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
  	@user = User.new
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def create
  	@user = User.new(params[:user])
  	if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  def destroy
    # User.find(params[:id]).destroy
    user_to_destroy = User.find(params[:id])
    user_to_destroy.destroy unless user_to_destroy.admin
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  def edit
    # there is the before_filter
    # @user = User.find(params[:id])    
  end

  def update
    # there is the before_filter
    # @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      # Handle a successful update.
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

    def not_signed_in_user
      if signed_in?
        redirect_to root_url
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
  
end
