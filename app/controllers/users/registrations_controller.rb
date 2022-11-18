# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def update
    if current_user.nil?
      render json: { status: 401, message: 'User has no active session' }, status: :unauthorized
      return
    end
    if current_user.update(user_params)
      render json: {
        status: { code: 200, message: 'User updated successfully', data: resource }
      }
    else
      render json: {
        status: { message: 'User could not be updated', errors: resource.errors.full_messages }#, status: :unprocessable_entity
      }
    end
    # super
  end

  private

  def respond_with(resource, options={})
    if resource.persisted?
      render json: {
        status: { code: 200, message: 'Signed up successfully', data: resource }
      }
    else
      render json: {
        status: { message: 'User could not be created successfully', errors: resource.errors.full_messages }, status: :unprocessable_entity
      }
    end
  end

  def user_params
    params.require(:user).permit(:email, :password, :role, :coin5, :coin10, :coin20, :coin50, :coin100)
  end

end
