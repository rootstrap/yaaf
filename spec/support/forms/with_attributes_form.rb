class WithAttributesForm < YAAF::Form
  attr_accessor :attributes

  def initialize(attributes)
    @attributes = attributes

    @models = [user]
  end

  def user
    @user ||= User.new(attributes)
  end
end
