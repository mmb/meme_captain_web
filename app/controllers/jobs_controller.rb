# Jobs controller.
class JobsController < ApplicationController
  def destroy
    head(:forbidden) unless admin?

    Delayed::Job.destroy(params[:id])
  end

  def index
    head(:forbidden) unless admin?

    @jobs = Delayed::Job.where(attempts: 0).order(:created_at)
  end
end
