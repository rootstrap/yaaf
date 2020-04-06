class UserWithCallbacks < ActiveRecord::Base
  self.table_name = 'users'

  attr_accessor :result

  validates :name, format: { with: /[a-zA-Z]+/ }
  after_validation :add_to_after_validation_counter, :add_again_to_after_validation_counter
  after_commit :add_to_after_commit_counter, :add_again_to_after_commit_counter
  before_save :add_to_before_save_counter
  after_rollback :add_to_after_rollback_counter
  after_save :add_to_after_save_counter
  before_validation :add_to_before_validation_counter
  before_save :add_again_to_before_save_counter
  after_validation :add_one_more_time_to_after_validation_counter

  private

  def add_to_before_validation_counter
    @result[:before_validation_counter] += 1
  end

  def add_to_after_validation_counter
    @result[:after_validation_counter] += 1
  end

  def add_again_to_after_validation_counter
    @result[:after_validation_counter] += 1
  end

  def add_one_more_time_to_after_validation_counter
    @result[:after_validation_counter] += 1
  end

  def add_to_before_save_counter
    @result[:before_save_counter] += 1
  end

  def add_again_to_before_save_counter
    @result[:before_save_counter] += 1
  end

  def add_to_after_save_counter
    @result[:after_save_counter] += 1
  end

  def add_to_after_commit_counter
    @result[:after_commit_counter] += 1
  end

  def add_again_to_after_commit_counter
    @result[:after_commit_counter] += 1
  end

  def add_to_after_rollback_counter
    @result[:after_rollback_counter] += 1
  end
end
