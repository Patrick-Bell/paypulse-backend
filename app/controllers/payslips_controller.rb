class PayslipsController < ApplicationController
  before_action :set_payslip, only: %i[ show update destroy ]
  before_action :set_current_user

  # GET /payslips
  def index
    @payslips = @current_user.payslips
    render json: @payslips
  end

  # GET /payslips/1
  def show

    @payslip = @current_user.payslips.find_by(id: params[:id])


    render json: @payslip
  end

  # POST /payslips
  def create
    @payslip = Payslip.new(payslip_params)
    @payslip.user = @current_user
    @payslip.username = @current_user.first_name + " " + @current_user.last_name

    Rails.logger.info "Creating payslip for user: #{@payslip.username} with params: #{payslip_params.inspect}"

    if @payslip.save
      render json: @payslip, status: :created, location: @payslip
    else
      render json: @payslip.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /payslips/1
  def update
    if @payslip.user != @current_user
      render json: { error: "You are not authorized to update this shift." }, status: :forbidden and return
    end

    if @payslip.update(payslip_params)
      render json: @payslip
    else
      render json: @payslip.errors, status: :unprocessable_entity
    end
  end

  # DELETE /payslips/1
  def destroy

    if @payslip.user != @current_user
      render json: { error: "You are not authorized to update this shift." }, status: :forbidden and return
    end


    @payslip.destroy!
  end

  # POST /payslips/build_payslip
 

  def get_payslip_shifts
    @payslip = Payslip.find(params[:id])
  
    # parse payslip.month and payslip.year into date range
    date = Date.parse("1 #{@payslip.month} #{@payslip.year}")
    start_of_month = date.beginning_of_month.beginning_of_day
    end_of_month = date.end_of_month.end_of_day
  
    @shifts = @current_user.shifts.where(date: start_of_month..end_of_month, status: 'complete')
    render json: @shifts
  end

  def get_year_payslips
    @year = Payslip.find(params[:id]).year

    @payslips = @current_user.payslips.where(year: @year)

    render json: @payslips

  end
  

  private

  def set_payslip
    @payslip = Payslip.find(params[:id])
  end

  def payslip_params
    params.require(:payslip).permit(:name, :month, :year, :gross, :net, :hours, :tax, :shifts, :rate, :status, :first, :finish)
  end
end
