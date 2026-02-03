class WithRollbackCallbacksForm < YAAF::Form
  attribute :email, :string
  attribute :name, :string

  attr_accessor :after_counter

  validates :name, format: { with: /[a-zA-Z]+/ }, allow_blank: true
  after_rollback { @after_counter += 1 }

  def initialize(args)
    super(args)

    @models = [user]
  end

  def user
    @user ||= User.new(email: email, name: name)
  end
end
