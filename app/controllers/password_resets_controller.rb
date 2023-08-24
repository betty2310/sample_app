class PasswordResetsController < ApplicationController
  before_action :find_user, only: :create
  before_action :load_user, :valid_user, :check_expired, only: %i(edit update)
  def new; end

  def edit; end

  def create
    @user.create_reset_digest
    @user.send_password_reset_email
    flash[:info] = t "password_reset_email_sent"
    redirect_to root_url
  end

  def update
    if user_params[:password].empty?
      @user.errors.add :password, t("error")
      render :edit
    elsif @user.update user_params
      log_in @user
      @user.update_column :reset_digest, nil
      flash[:success] = t "password_has_been_reset"
      redirect_to @user
    else
      render :edit
    end
  end

  private
  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def find_user
    @user = User.find_by email: params.dig(:password_reset, :email)&.downcase
    return if @user.present?

    flash.now[:danger] = t "email_not_found"
    render :new
  end

  def load_user
    @user = User.find_by email: params[:email]
    return if @user.present?

    flash.now[:danger] = t "users.not_found"
    render :new
  end

  def valid_user
    return if @user.activated && @user.authenticated?(:reset, params[:id])

    flash[:danger] = t "users.is_in_actived"
    redirect_to root_url
  end

  def check_expired
    return unless @user.password_reset_expired?

    flash[:danger] = t "users.password.reset_expired"
    redirect_to new_password_reset_url
  end
end
