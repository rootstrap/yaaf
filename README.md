# YAAF

![CI](https://github.com/rootstrap/yaaf/workflows/CI/badge.svg)
[![Maintainability](https://api.codeclimate.com/v1/badges/c3dea064e1003b700260/maintainability)](https://codeclimate.com/github/rootstrap/yaaf/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/c3dea064e1003b700260/test_coverage)](https://codeclimate.com/github/rootstrap/yaaf/test_coverage)

YAAF (Yet Another Active Form) is a gem that let you create form objects in an easy and Rails friendly way. It makes use of ActiveRecord and ActiveModel facilities in order to provide you with a form object that behaves pretty much like a model and is completely configurable.

We were going to name this gem `ActiveForm` to follow Rails naming conventions but given there are a lot of form object gems named like that we preferred to go with `YAAF`.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'yaaf'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install yaaf

## Usage

In order to use a `YAAF` form object, you need to inherit from `YAAF::Form` and define the `@models` of the form, for example:
```ruby
# app/forms/registration_form.rb

class RegistrationForm < YAAF::Form
  attr_accessor :user_attributes

  def initialize(attributes)
    super(attributes)
    @models = [user]
  end

  def user
    @user ||= User.new(user_attributes)
  end
end
```

By doing that you can work with your form object in your controller such as you'd do with a model.
```ruby
# app/controllers/registrations_controller.rb

class RegistrationsController < ApplicationController
  def create
    registration_form = RegistrationForm.new(user_attributes: user_params)

    if registration_form.save
      redirect_to registration.user
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
```

Form objects supports calls to `save`, `save!`, `valid?`, `invalid?` and `errors` such as any `ActiveModel` model. The return values match the corresponding `ActiveModel` methods.

When saving or validating a form object, it will automatically validate all its models and promote the error to the form object itself, so they are accessible to you directly from the form object.

Form objects can also define validations like:
```ruby
# app/forms/registration_form.rb

class RegistrationForm < YAAF::Form
  validates :phone, presence: true
  validate :a_custom_validation

  # ...

  def a_custom_validation
    # ...
  end
end
```

Validations can be skipped the same way as for `ActiveModel` models:
```ruby
# app/controllers/registrations_controller.rb

class RegistrationsController < ApplicationController
  def create
    registration_form = RegistrationForm.new(user_attributes: user_params)

    registration_form.save!(validate: false)
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
```

Form objects support the saving of multiple models at the same time, to prevent leaving the system in a bad state all the models are saved within a DB transaction.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rootstrap/yaaf. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/rootstrap/yaaf/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the YAAF project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/yaaf/blob/master/CODE_OF_CONDUCT.md).
