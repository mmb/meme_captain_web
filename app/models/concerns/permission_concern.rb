# frozen_string_literal: true

# ActiveRecord::Model mixin to check a user's access to a model.
module PermissionConcern
  extend ActiveSupport::Concern

  def can_be_edited_by?(check_user)
    return false if check_user.nil?
    return true if check_user.is_admin
    user == check_user
  end
end
