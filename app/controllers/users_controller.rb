class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_filter :non_signed_in_user, only: [:new, :create]
  before_filter :user_not_self, only: [:edit, :update]
  before_filter :admin_user, only: :destroy
  before_filter :user_self, only: :destroy

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    @user = User.new
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

  def index
    @users = User.paginate(page: params[:page])
  end

  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = 'Profile updated'
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = 'User destroyed.'
    redirect_to users_url
  end

  def following
    @title = 'Following'
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = 'Followers'
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

  def non_signed_in_user
    if signed_in?
      redirect_to root_path
    end
  end

  def user_not_self
    @user = User.find(params[:id])
    if !current_user?(@user)
      redirect_to(root_path)
    end
  end

  def user_self
    @user = User.find(params[:id])
    if current_user?(@user)
      redirect_to(root_path)
    end
  end

  def admin_user
    if !current_user.admin?
      redirect_to(root_path)
    end
  end
end
