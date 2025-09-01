class GoalsController < ApplicationController
  before_action :set_goal, only: %i[ show update destroy ]
  before_action :set_current_user

  # GET /goals
  def index
    @goals = @current_user.goals

    render json: @goals
  end

  # GET /goals/1
  def show
    @goal = @current_user.goals.find_by(id: params[:id])

    render json: @goal
  end

  # POST /goals
  def create
    @goal = Goal.new(goal_params)
    @goal.user = @current_user

    if @goal.save
      render json: @goal, status: :created, location: @goal
    else
      render json: @goal.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /goals/1
  def update
    if @goal.user != @current_user
      render json: { error: "You are not authorized to update this shift." }, status: :forbidden and return
    end

    if @goal.update(goal_params)
      render json: @goal
    else
      render json: @goal.errors, status: :unprocessable_entity
    end
  end

  # DELETE /goals/1
  def destroy
    if @goal.user != @current_user
      render json: { error: "You are not authorized to update this shift." }, status: :forbidden and return
    end

    @goal.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_goal
      @goal = Goal.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def goal_params
      params.expect(goal: [ :title, :start_date, :finish_date, :target, :period, :goal_type ])
    end
end
