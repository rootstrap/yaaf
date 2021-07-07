class WithCallbackFormSaving < YAAF::Form
  attr_accessor :email, :name, :comment

  after_save :save_comment

  def initialize(args)
    super(args)

    @models = [user]
  end

  def user
    @user ||= User.new(email: email, name: name)
  end

  def save_comment
    Comment.new(user_id: user.id, text: comment).save!
  end
end
