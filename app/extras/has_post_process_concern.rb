# ActiveRecord::Model mixin for models that need post-processing by delayed
# job after they have been committed.
#
# Requires a boolean column on the model called "work_in_progress".
module HasPostProcessConcern
  extend ActiveSupport::Concern

  included do
    after_commit :create_post_process_job
  end

  def create_post_process_job
    self.delay.post_process_job if work_in_progress
  end

  def post_process_job
    post_process

    self.work_in_progress = false
    save!
  end

end
