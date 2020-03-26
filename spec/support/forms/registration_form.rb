class RegistrationForm < YAAF::Form
  attr_accessor :name

  validates :name, format: { with: /[a-zA-Z]+/ }

  def initialize(args)
    super(args)

    @models = [user]
  end

  def user
    @user ||= User.new(name: name)
  end
end
