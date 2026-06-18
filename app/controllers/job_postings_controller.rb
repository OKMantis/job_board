class JobPostingsController < ApplicationController
  def index
    @jobs = JobPosting.active.not_expired

    # Each filter chains on the previous relation
    @jobs = @jobs.remote if params[:remote] == "1"
    @jobs = @jobs.featured if params[:featured] == "1"
    @jobs = @jobs.search(params[:q])
    @jobs = @jobs.salary_between(params[:salary_min], params[:salary_max])
    @jobs = @jobs.expiring_soon(7) if params[:expiring_soon] == "1"
    @jobs = @jobs.for_location(params[:location])

    # By category takes an object; look it up first
    if params[:category_id].present?
      @category = Category.find_by(id: params[:category_id])
      @jobs = @jobs.by_category(@category) if @category
    end

    @jobs = @jobs.includes(:company, :category).recent
    @categories = Category.all
  end

  def show
    @job = JobPosting.active.not_expired.find(params[:id])
    @related = JobPosting.active
                         .by_category(@job.category)
                         .where.not(id: @job.id)
                         .limit(3)
  end
end
