# frozen_string_literal: true

# Jobs controller.
class JobsController < ApplicationController
  def destroy
    head(:forbidden) unless admin?

    Delayed::Job.destroy(params[:id])
  end
end
