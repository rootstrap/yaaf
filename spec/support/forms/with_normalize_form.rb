class WithNormalizeForm < YAAF::Form
  attribute :email, :string
  attribute :name, :string

  normalizes :email, with: ->(email) { email.strip.downcase }
  normalizes :name, with: ->(name) { name.strip.titleize }

  def initialize(args)
    super(args)

    @models = [user]
  end

  def user
    @user ||= User.new(email: email, name: name)
  end
end
