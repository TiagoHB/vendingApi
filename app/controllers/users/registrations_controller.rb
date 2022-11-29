# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  def create
    user = User.new(user_params)
    if user.save
      render json: {
        status: { code: 200, message: 'User created successfully', data: user }
      }
    else
      render json: {
        status: { message: 'User could not be created', errors: user.errors.full_messages }#, status: :unprocessable_entity
      }
    end
    
  end

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
    
  end

  def destroy
    if current_user.nil?
      render json: { status: 401, message: 'Error removing user. Only signed in user can remove itself.' }
      return
    else
      username = current_user.username
      if current_user.destroy
        render json: { status: 200, message: "User #{username} removed." }, status: :ok
      else
        render json: { status: 401, message: 'Error removing user.', errors: resource.errors.full_messages }#, status: :unauthorized
      end
    end
  end

  private

  def respond_with(resource, options={})
    if resource.persisted?
      render json: {
        status: { code: 200, message: 'Signed up successfully', data: resource }
      }
    else
      render json: {
        status: { message: 'User could not be created. ', errors: resource.errors.full_messages }#, status: :unprocessable_entity
      }
    end
  end

  def respond_to_on_destroy
    unless current_user
      render json: { status: 401, message: 'User is not logged.' }#, status: :unauthorized
    end
  end

  def user_params
    params.require(:user).permit(:username, :email, :password, :role, :coin5, :coin10, :coin20, :coin50, :coin100)
  end

end
