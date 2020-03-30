class WithSaveCallbacksForm < YAAF::Form
  attr_accessor :email, :name, :before_counter, :after_counter

  validates :name, format: { with: /[a-zA-Z]+/ }, allow_blank: true
  before_save :add_to_before_counter
  after_save { @after_counter += 1 }

  def initialize(args)
    super(args)

    @models = [user]
  end

  def user
    @user ||= User.new(email: email, name: name)
  end

  private

  def add_to_before_counter
    @before_counter += 1
  end
end
