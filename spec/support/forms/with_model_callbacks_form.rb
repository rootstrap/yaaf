class WithModelCallbacksForm < YAAF::Form
  attr_accessor :email, :name, :result

  def initialize(args)
    super(args)

    @models = [user]

    user.result = Hash.new(0)
  end

  def user
    @user ||= UserWithCallbacks.new(email: email, name: name)
  end
end
