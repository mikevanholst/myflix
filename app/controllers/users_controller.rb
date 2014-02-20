class UsersController < ApplicationController

  before_action :require_user, only: [:show ]

  def new
    @user = User.new
  end

  def new_with_invitation_token

    invitation = Invitation.where(token: (params[:token])).first
    if invitation
      @user = User.new(email: invitation.recipient_email)
      @invitation_token = invitation.token
      render :new
    else
      redirect_to failed_token_path
    end
  end

  def create
    @user = User.new(user_params)
    result = UserSignup.new(@user).sign_up(params[:invitation_token])
    if result.successful?
      flash[:success] = "Your subscription has been activated!"
      sign_in_new_user
    else
      flash[:error] =  result.error_message
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  private



  def user_params
    params.require(:user).permit(:email, :full_name, :password)
  end

  def sign_in_new_user
    session[:user_id] = @user.id
    redirect_to home_path
  end

 
end
