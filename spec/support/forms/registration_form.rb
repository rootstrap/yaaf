class RegistrationForm < YAAF::Form
  attribute :email, :string
  attribute :name, :string

  validates :name, format: { with: /[a-zA-Z]+/ }, allow_blank: true

  def initialize(args)
    super(args)

    @models = [user]
  end

  def user
    @user ||= User.new(email: email, name: name)
  end
end
