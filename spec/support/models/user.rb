class User < ActiveRecord::Base
  validates :name, presence: true

  validate :custom_validation

  def custom_validation
    'A validation method used in the specs'
  end
end
