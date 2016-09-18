# Superclass for all models.
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
