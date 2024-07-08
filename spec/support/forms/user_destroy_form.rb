class UserDestroyForm < YAAF::Form
  attr_accessor :email, :name

  before_save :mark_user_for_destruction

  def initialize(args)
    super(args)

    @models = [user]
  end

  def user
    @user ||= User.find_or_initialize_by(email: email)
  end

  private

  def mark_user_for_destruction
    user.mark_for_destruction
  end
end
