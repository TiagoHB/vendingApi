# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  respond_to :json

  private

  def respond_with(resource, options={})
    render json: { code: 200, message: 'Signed in with success.', data: current_user }
  end

  def respond_to_on_destroy
    if request.headers['Authorization'].blank?
      render json: { code: 401, message: 'Missing header data.' }
      return
    end
    
    jwt_payload = JWT.decode(request.headers['Authorization'].split(' ')[1], Rails.application.credentials.devise_jwt_secret_key).first
    # debugger
    current_user = User.find_by_jti(jwt_payload['jti'])
    if current_user
      render json: { code: 200, message: 'Signed out with success.' }
    else
      render json: { code: 401, message: 'User is not logged.' }
    end
  end

  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
