class WithRollbackCallbacksForm < YAAF::Form
  attr_accessor :name, :after_counter

  validates :name, format: { with: /[a-zA-Z]+/ }
  after_rollback { @after_counter += 1 }

  def initialize(args)
    super(args)

    @models = [user]
  end

  def user
    @user ||= User.new(name: name)
  end
end
