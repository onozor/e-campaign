class UsersController < ApplicationController
  before_filter :set_user, only: [:edit, :update, :show, :destroy]
  before_filter :get_referres, only: [:new, :create, :edit]
  before_action :authenticate_user!, except:[:new, :create]
  #before_filter :authorise_user, only: [:show]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.registration_confirmation(@user, login_url+"/#{@user.auth_token}").deliver
      flash[:success] = "Please Check Your Email to Verify your Registration!"
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      redirect_to users_path
    else
      render :edit
    end
  end

  def show
  end

  def get_referres
    @registereds = User.find_referers
  end

  def index
    @users = User.get_all
  end

  private
  def set_user
    @user = User.where(id: params[:id]).first
    if @user.blank?
      redirect_to users_path, alert: 'Sorry, User not found.'
    else
      @user.prepare_user
    end
  end

  def user_params
      params.require(:user).permit(:first_name, :last_name, :phone_number,  :email, :password, :password_confirmation, :password_digest, :refer_id)
  end

end
