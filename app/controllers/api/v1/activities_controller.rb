class Api::V1::ActivitiesController < ApplicationController

  # GET /api/v1/activities
  def index
    activities = Activity.all.order(started_at: :desc)
    render json: activities
  end

  # GET /api/v1/activities/:id
  def show
    activity = Activity.find(params[:id])
    render json: activity
  end

  # POST /api/v1/activities
  def create
    activity = Activity.new(activity_params)
    if activity.save
      render json: activity, status: :created
    else
      render json: { errors: activity.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/activities/:id
  def update
    activity = Activity.find(params[:id])
    if activity.update(activity_params)
      render json: activity
    else
      render json: { errors: activity.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/activities/:id
  def destroy
    activity = Activity.find(params[:id])
    activity.destroy
    head :no_content
  end

  private

  def activity_params
    params.require(:activity).permit(
      :kind,
      :category,
      :started_at,
      :duration,
      :notes,
      data: {}
    )
  end
end