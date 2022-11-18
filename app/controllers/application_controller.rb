class ApplicationController < ActionController::API
  before_action :configure_permitted_parameters, if: :devise_controller?
  respond_to :json

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :role])
    devise_parameter_sanitizer.permit(:sign_in, keys: [:login, :password, :password_confirmation])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :role, :coin5, :coin10, :coin20, :coin50, :coin100])
  end
end
