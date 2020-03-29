class RegistrationForm < YAAF::Form
  attr_accessor :email, :name

  validates :name, format: { with: /[a-zA-Z]+/ }

  def initialize(args)
    super(args)

    @models = [user]
  end

  def user
    @user ||= User.new(email: email, name: name)
  end
end
