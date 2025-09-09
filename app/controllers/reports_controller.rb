class ReportsController < ApplicationController
  before_action :set_report, only: %i[ show update destroy ]
  before_action :set_current_user

  # GET /reports
  def index
    @reports = @current_user.reports.all
  
    @summary = @reports.map do |report|
      start_date = report.start_date
      end_date = report.end_date
      shifts = @current_user.shifts.where(date: start_date..end_date)
      expenses = @current_user.expenses.where(created_at: start_date..end_date)
  
      {
        id: report.id,
        name: report.name,
        start_date: start_date,
        end_date: end_date,
        shifts: shifts,
        expenses: expenses,
      }
    end
  
    render json: @summary
  end
  

  # GET /reports/1
  def show
    render json: @report
  end

  # POST /reports
  def create
    @report = Report.new(report_params)
    @report.user = @current_user

    if @report.save
      render json: @report, status: :created, location: @report
    else
      render json: @report.errors, status: :unprocessable_entity
    end

  
    def get_report_shifts
      start_date = params[:start_date]
      end_date = params[:end_date]

      @shifts = @current_user.shifts.where(date: start_date..end_date)

      render json: @shifts
    end

    
  end

  # PATCH/PUT /reports/1
  def update
    if @report.update(report_params)
      render json: @report
    else
      render json: @report.errors, status: :unprocessable_entity
    end
  end

  # DELETE /reports/1
  def destroy
    @report.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_report
      @report = Report.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def report_params
      params.expect(report: [ :name, :start_date, :end_date, :user ])
    end
end
