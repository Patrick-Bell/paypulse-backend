class UsersController < ApplicationController
  before_action :set_user, only: %i[ show destroy ]
  before_action :set_current_user

  include ActionController::Cookies
  JWT_SECRET_KEY = ENV['JWT_SECRET_KEY']


  # GET /users
  def index
    @users = User.all

    render json: @users
  end

  # GET /users/1
  def show
    render json: @current_user
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @current_user.update(user_params)
      token = generate_jwt_token(@current_user)
      cookie_options = {
        httponly: true,
        secure: Rails.env.production?,
        same_site: :strict,
        expires: 1.hour.from_now,
        value: token
    }
    cookies[:jwt] = cookie_options
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy!
  end


  # Password Routes

  def change_password
    current_password = password_params[:current_password]
    new_password = password_params[:new_password]
    confirm_password = password_params[:confirm_password]

    Rails.logger.info "Current Password: #{current_password}"
    Rails.logger.info "New Password: #{new_password}"
    Rails.logger.info "Confirm Password: #{confirm_password}"
  
    if new_password != confirm_password
      return render json: { error: 'New password and confirmation do not match' }, status: :unprocessable_entity
    end
  
    unless @current_user.authenticate(current_password)
      return render json: { error: 'Current password is incorrect' }, status: :unauthorized
    end
  
    if @current_user.update(password: new_password, password_last_updated: Time.current)
      render json: { message: 'Password changed successfully' }, status: :ok
    else
      render json: { errors: @current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end
  

  def generate_jwt_token(user)
    payload = { user_id: user.id, email: user.email }
    JWT.encode(payload, JWT_SECRET_KEY, 'HS256')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.expect(user: [ :first_name, :last_name, :role, :dob, :job, :email, :password, :confirm_password, :password_last_updated ])
    end


  def password_params
    params.require(:user).permit(:current_password, :new_password, :confirm_password)
  end
  

end
