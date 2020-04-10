# Using YAAF with Devise

[Devise](https://github.com/heartcombo/devise) is a gem that provides flexible authentication solution for Rails apps.

## Usage

Set the `resource_class` on your controller that inherits from `Devise::RegistrationsController` to be the class of the form object. In your form object, delegate missing methods that Devise might call to the `user`. If you want to be specific on which methods to delegate that's fine too.

For example, a simple registration form will look like this:

```ruby
# app/forms/registration_form.rb

class RegistrationForm < ApplicationForm
  attr_accessor :first_name, :last_name, :email, :password,
                :password_confirmation

  # To let Devise treat the form object as it were the actual user object
  delegate_missing_to :user

  def initialize(args = {})
    super(args)

    @models = [user]
  end

  # Override this method to let Devise know whether the form object saved the resource correctly or not
  # `delegate_missing_to :user` will not be enough because the user method has been memoized hence
  # the `persisted?` attribute will have an outdated value
  def persisted?
    user.persisted?
  end

  private

  def user
    @user ||= User.new(
      email: email,
      first_name: first_name,
      last_name: last_name,
      password: password,
      password_confirmation: password_confirmation
    )
  end
end
```

```ruby
# app/controllers/users/registrations_controller.rb

module Users
  class RegistrationsController < Devise::RegistrationsController
    private

    def resource_class
      RegistrationForm
    end
  end
end
```

## Got questions?

Feel free to [create an issue](https://github.com/rootstrap/yaaf/issues) and we'll discuss about it.

YAAF is maintained by [Rootstrap](http://www.rootstrap.com) with the help of our [contributors](https://github.com/rootstrap/yaaf/contributors).

[![YAAF](../images/footer.png)](http://www.rootstrap.com)
