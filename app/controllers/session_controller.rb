class SessionController < ApplicationController
    require 'jwt'

    include ActionController::Cookies
    JWT_SECRET_KEY = ENV['JWT_SECRET_KEY']


    def login
        user = User.find_by(email: params[:user][:email])
        return render json: { error: 'User not found' }, status: :not_found unless user
      
        if user.authenticate(params[:user][:password])
          token = generate_jwt_token(user)
      
          cookies[:jwt] = {
            value: token,
            httponly: true,
            expires: 2.hours.from_now,
            secure: Rails.env.production? ? true : false,
            same_site: Rails.env.development? ? :lax : :none,
            path: '/'           
            }

      
          render json: { message: 'Login successful', user: user }, status: :ok
        else
          render json: { error: 'Invalid password' }, status: :unauthorized
        end
      end
      
      
      def logout
        cookies.delete(:jwt,
        path: '/',
        secure: Rails.env.production? ? true : false,
        same_site: Rails.env.development? ? :lax : :none,
        httponly: true,
        signed: true,
      )
        render json: { message: 'Logout successful' }, status: :ok
      end    

    def current_user
        get_current_user || { error: 'No user logged in' }
    end

    def get_current_user
    end

    def generate_jwt_token(user)
        payload = { user_id: user.id, email: user.email }
        JWT.encode(payload, JWT_SECRET_KEY, 'HS256')
      end
      


end
