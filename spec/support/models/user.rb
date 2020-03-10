class User < ActiveRecord::Base
  validates :name, presence: true
end
