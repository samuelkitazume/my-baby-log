class Api::V1::ActivitiesController < ApplicationController

  # GET /api/v1/activities
  def index
    activities = Activity.all
  
    # 🔍 Filtros
    activities = activities.where(kind: params[:kind]) if params[:kind].present?
    activities = activities.where(category: params[:category]) if params[:category].present?
  
    if params[:from].present? && params[:to].present?
      activities = activities.where(started_at: params[:from]..params[:to])
    elsif params[:from].present?
      activities = activities.where("started_at >= ?", params[:from])
    elsif params[:to].present?
      activities = activities.where("started_at <= ?", params[:to])
    end

    sort_by = params[:sort_by].presence_in(Activity.column_names) || "started_at"
    order = params[:order] == "asc" ? "asc" : "desc"

    activities = activities.order("#{sort_by} #{order}")
  
    # 🧮 Total antes da paginação
    total = activities.count
  
    # 📃 Paginação
    page = (params[:page] || 1).to_i
    per_page = (params[:per_page] || 25).to_i
    total_pages = (total.to_f / per_page).ceil
  
    activities = activities.offset((page - 1) * per_page).limit(per_page)
  
    render json: {
      meta: {
        page: page,
        per_page: per_page,
        total: total,
        total_pages: total_pages
      },
      data: activities
    }
  end

  # GET /api/v1/activities/:id
  def show
    activity = Activity.find(params[:id])
    render json: activity
  end

  # POST /api/v1/activities
  def create
    raw_params = activity_params.to_h
    @activity = Activity.new(
      kind: raw_params["kind"],
      category: raw_params["category"],
      started_at: raw_params["started_at"],
      notes: raw_params["notes"],
      data: Activity.build_data(raw_params["kind"], raw_params["data"]) # ou ActivityDataBuilder.build(...)
    )
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

  def schema
    kind = params[:kind]
    render json: {
      kind: kind,
      expected_fields: Activity::DATA_FIELDS_BY_KIND[kind] || []
    }
  end
end