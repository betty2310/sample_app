class SessionsController < ApplicationController
  before_action :find_user, only: :create
  before_action :authenticate_user, only: :create

  def new; end

  def create
    if @user.activated
      log_in @user
      params[:session][:remember_me] == "1" ? remember(@user) : forget(@user)
      redirect_back_or @user
    else
      flash[:warning] = t "account_not_activated"
      redirect_to root_url
    end
  end

  def destroy
    log_out
    redirect_to root_path
  end

  private

  def find_user
    @user = User.find_by email: params.dig(:session, :email)&.downcase
    return unless @user.nil?

    flash.now[:danger] = t "invalid_email_password_combination"
    render :new
  end

  def authenticate_user
    return if @user.authenticate params.dig(:session, :password)

    flash.now[:danger] = t "invalid_email_password_combination"
    render :new
  end
end
