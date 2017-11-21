# frozen_string_literal: true

module TokenAuth
  # Superclass for models.
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
  end
end
