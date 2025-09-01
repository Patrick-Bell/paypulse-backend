class SessionController < ApplicationController

    include ActionController::Cookies
    JWT_SECRET_KEY = ENV['JWT_SECRET_KEY']



    def login
        user = User.find_by(email: params[:user][:email])

        if !user
            render json: { error: 'User not found' }, status: :not_found
            return
        end

        if user.authenticate(params[:user][:password])
            token = generate_jwt_token(user)

            cookie_options = {
                httponly: true,
                secure: Rails.env.production?,
                same_site: :strict,
                expires: 1.hour.from_now,
                value: token
            }

            cookies[:jwt] = cookie_options
            

            render json: { token: token, user: user, message: 'Login successful' }, status: :ok
        else
            render json: { error: 'Invalid password' }, status: :unauthorized
        end

    end




    def logout
        cookies.delete(:jwt)
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
