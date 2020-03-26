class WithValidationCallbacksForm < YAAF::Form
  attr_accessor :name, :before_counter, :after_counter

  validates :name, format: { with: /[a-zA-Z]+/ }
  before_validation :add_to_before_counter
  after_validation { @after_counter += 1 }

  def initialize(args)
    super(args)

    @models = [user]
  end

  def user
    @user ||= User.new(name: name)
  end

  private

  def add_to_before_counter
    @before_counter += 1
  end
end
