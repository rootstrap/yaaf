class MultipleErrorsForm < YAAF::Form
  attribute :email, :string
  attribute :name, :string

  validates :name, format: { with: /[a-zA-Z]+/ }
  validates :email, format: { with: /\S+@\S+\.\S+/ }

  def initialize(args)
    super(args)

    @models = [user]
  end

  def user
    @user ||= User.new(email: email, name: name)
  end
end
