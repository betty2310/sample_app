class ApplicationController < ActionController::Base
  before_action :set_locale
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
  include SessionsHelper
  include Pagy::Backend

  private
  # confirm logged in user
  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "users.logged_in_user.danger"
    redirect_to login_url
  end
end
