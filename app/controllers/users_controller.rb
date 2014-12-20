class UsersController < ApplicationController
  before_filter :set_user, only: [:edit, :update, :show, :destroy]
  before_filter :get_referres, only: [:new, :create, :edit]
  before_action :authenticate_user!, :except =>  [:new, :create, :set_complete]


  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_confirmation_link if @user
      session[:user_id] = nil
      flash[:success] = "Please Check Your Email to Verify your Registration!"
      redirect_to new_session_path
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

  def set_complete
    user = User.find_by_confirmation_token!(params[:id])
    if user
    user.update_attribute(:registration_complete, true)
    redirect_to new_session_path, notice: "Your Account has been confirmed!"
    else
     flash.now.alert ="oops! unable to comfirm you account"
      render 'sessions/new'
    end
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
      params.require(:user).permit(:first_name, :last_name, :phone_number,  :email, :password, :password_confirmation, :password_digest, :refer_id, :conformation_token)
  end

end
