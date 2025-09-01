class ApplicationController < ActionController::API

    include ActionController::Cookies

    before_action :set_current_user

    JWT_SECRET_KEY = ENV['JWT_SECRET_KEY']

  
    def decode_token
      token = cookies[:jwt]
      return nil if token.blank?
  
      begin
        decoded_token = JWT.decode(token, JWT_SECRET_KEY, true, { algorithm: 'HS256' })
        user_id = decoded_token[0]['user_id']
        User.find_by(id: user_id)
      rescue JWT::DecodeError => e
        Rails.logger.warn "JWT Decode Error: #{e.message}"
        nil
      end
    end
  
    def set_current_user
      @current_user = decode_token
    end
  
    def authorize_user
      render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user.present?
    end
  
    def authorize_admin
      unless @current_user&.admin?
        render json: { error: 'Forbidden' }, status: :forbidden
      end
    end
  
    def authorize_admin_and_user
      unless @current_user && (@current_user.role == admin || @current_user.role == user)
        render json: { error: 'Forbidden' }, status: :forbidden
      end
    end

    def current_user
     if @current_user
        render json: @current_user
      else
        render json: { error: 'No current user found' }, status: :unauthorized
      end
    end


  end
  