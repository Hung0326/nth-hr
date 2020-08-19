# frozen_string_literal: true

# Application controller
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale

  def set_locale
    locale = (user_signed_in? ? current_user.language : params[:locale].to_s.strip).to_sym
    I18n.locale = I18n.available_locales.include?(locale) ? locale : I18n.default_locale
  end

  def default_url_options
    { locale: I18n.locale }
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :email, :cv, :password) }
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:name, :email, :cv, :password, :current_password) }
  end
end
