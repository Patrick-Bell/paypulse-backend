class ShiftsController < ApplicationController
  require 'icalendar'


  before_action :set_shift, only: %i[ show update destroy ]
  before_action :set_current_user

  # GET /shifts
  def index
    @shifts = @current_user.shifts

    render json: @shifts
  end

  # GET /shifts/1
  def show
    @shift = @current_user.shifts.find_by(id: params[:id])
  
    if @shift.nil?
      render json: { error: 'Shift not found or you do not have access' }, status: :not_found
      return
    end
  
    render json: @shift
  end
  
  def month_shifts

    month = Date.current
    @shifts = @current_user.shifts.where(date: month.beginning_of_month..month.end_of_month).includes(:expenses)

    render json: @shifts, include: :expenses
  end


  def previous_month_shifts
    month = Date.current.prev_month
    @shifts = @current_user.shifts.where(date: month.beginning_of_month..month.end_of_month)

    render json: @shifts
  end

  def shift_dates
    start_date = params[:start_date].to_date
    finish_date = params[:finish_date].to_date

    @shifts = @current_user.shifts.where(date: start_date..finish_date)

    render json: @shifts, status: ok
  end

  def get_week_shifts
    @start_date = Date.current.beginning_of_week
    @finish_date = Date.current.end_of_week
  
    @shifts = @current_user.shifts.where(date: @start_date..@finish_date)
  
    render json: { shifts: @shifts, start: @start_date, finish: @finish_date }, status: :ok
  end

  def shifts_by_date
    goal_date = params[:goal_date].present? ? Date.parse(params[:goal_date]) : Date.today
    period = params[:period]
    Rails.logger.info "Goal date: #{goal_date}, Period: #{period}"
  
    start_date, finish_date =
      case period
      when 'month'
        [goal_date.beginning_of_month, goal_date.end_of_month]
      when 'year'
        [goal_date.beginning_of_year, goal_date.end_of_year]
      else
        render json: { error: "Invalid period: must be 'month' or 'year'" }, status: :unprocessable_entity and return
      end
  
    # If Shift.date is a `date` column:
    @shifts = @current_user.shifts.where(date: start_date..finish_date)
  
    render json: @shifts, status: :ok
  end
  
  def calendar_event
    shift = Shift.find(params[:id])
  
    # Combine date with start and finish times
    start_dt = DateTime.parse("#{shift.date} #{shift.start_time.strftime('%H:%M:%S')}")
    end_dt = DateTime.parse("#{shift.date} #{shift.finish_time.strftime('%H:%M:%S')}")
  
    # Handle overnight shifts (e.g. finish_time is 00:00 or earlier than start_time)
    end_dt += 1.day if end_dt <= start_dt
  
    cal = Icalendar::Calendar.new
    event = Icalendar::Event.new
  
    event.dtstart = Icalendar::Values::DateTime.new(start_dt, 'tzid' => 'Europe/London')
    event.dtend = Icalendar::Values::DateTime.new(end_dt, 'tzid' => 'Europe/London')
    event.summary = "#{shift.name} - #{shift.location}"
    event.description = "#{shift.name} | #{shift.start_time.strftime('%H:%M')} - #{shift.finish_time.strftime('%H:%M')}"
    event.location = shift.location
  
    cal.add_event(event)
    cal.publish
  
    send_data cal.to_ical,
              type: 'text/calendar; charset=utf-8',
              disposition: 'attachment',
              filename: "shift_#{shift.id}.ics"
  end
  
  


  

  # POST /shifts
  def create
    @shift = Shift.new(shift_params)
    @shift.user = @current_user
  
    if @shift.save
      if params[:shift][:expenses].present?
        params[:shift][:expenses].each do |expense|
          @shift.expenses.create(
            name: expense[:name],
            amount: expense[:amount],
            notes: expense[:notes],
            expensable: expense[:expensable]
          )
        end
      end
  
      render json: @shift, include: :expenses, status: :created
    else
      render json: @shift.errors, status: :unprocessable_entity
    end
  end
  

  # PATCH/PUT /shifts/1
  def update

    if @shift.user != @current_user
      render json: { error: "You are not authorized to update this shift." }, status: :forbidden and return
    end

    if @shift.update(shift_params)
      render json: @shift
    else
      render json: @shift.errors, status: :unprocessable_entity
    end
  end

  # DELETE /shifts/1
  def destroy
    if @shift.user != @current_user
      render json: { error: "You are not authorized to delete this shift." }, status: :forbidden and return
    end

    @shift.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shift
      @shift = Shift.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def shift_params
      params.expect(shift: [ :name, :start_time, :finish_time, :rate, :pay, :notes, :hours, :client, :location, :date, :status, :company ])
    end
end
