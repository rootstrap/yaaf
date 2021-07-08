class WithCallbackExceptionRaising < YAAF::Form
  attr_accessor :callback_exception

  after_save :raise_exception, if: :callback_exception?

  def initialize(args)
    super(args)

    @models = [user]
  end

  def callback_exception?
    !callback_exception.nil?
  end

  def user
    @user ||= User.new(email: 'test@example.com', name: 'Sample User')
  end

  private

  def exception
    case callback_exception.to_s
    when ActiveRecord::RecordInvalid.to_s
      callback_exception.new(self)
    when ActiveRecord::RecordNotSaved.to_s
      callback_exception.new("Couldn't save record", self)
    when ActiveModel::ValidationError.to_s
      callback_exception.new(self)
    when ActiveRecord::NotNullViolation.to_s
      callback_exception.new
    end
  end

  def raise_exception
    raise exception
  end
end
