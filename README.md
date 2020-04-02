# YAAF

![CI](https://github.com/rootstrap/yaaf/workflows/CI/badge.svg)
[![Maintainability](https://api.codeclimate.com/v1/badges/c3dea064e1003b700260/maintainability)](https://codeclimate.com/github/rootstrap/yaaf/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/c3dea064e1003b700260/test_coverage)](https://codeclimate.com/github/rootstrap/yaaf/test_coverage)

YAAF (Yet Another Active Form) is a gem that let you create form objects in an easy and Rails friendly way. It makes use of `ActiveRecord` and `ActiveModel` features in order to provide you with a form object that behaves pretty much like a Rails model, and still be completely configurable.

We were going to name this gem `ActiveForm` to follow Rails naming conventions but given there are a lot of form object gems named like that we preferred to go with `YAAF`.

## Table of Contents

- [Motivation](#motivation)
- [Installation](#installation)
- [Usage](#usage)
  - [Setting up a form object](#setting-up-a-form-object)
  - [#initialize](#initialize)
  - [#valid?](#valid?)
  - [#invalid?](#invalid?)
  - [#errors](#errors)
  - [#save](#save)
  - [#save!](#save!)
  - [Validations](#validations)
  - [Callbacks](#callbacks)
- [Links](#links)
- [Development](#development)
- [Contributing](#contributing)
- [License](#license)
- [Code of Conduct](#code-of-conduct)
- [Credits](#credits)

## Motivation

Form Objects is a design pattern that allows us to:
1. Keep views, models and controllers clean
2. Create/update multiple models at the same time
3. Keep business logic validations out of models

There are some other form objects gems but we felt none of them provided us all the features that we expected:
1. Form objects behaves like a Rails model
2. Easy to customize
3. Simple and easy to understand implementation
4. Gem is well tested and maintained

For this reason we decided to build our own Form Object implementation. After several months in production without issues we decided to extract it into a gem to share it with the community.

If you want to learn more about Form Objects you can check out [these great articles](#links)

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

### Setting up a form object

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

Form objects supports calls to [valid?](#valid?), [invalid?](#invalid?), [errors](#errors), [save](#save), [save!](#save!), such as any `ActiveModel` model. The return values match the corresponding `ActiveModel` methods.

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

A good practice would be to create an empty `ApplicationForm` and make your form objects inherit from it. This way you have a centralized place to customize any `YAAF` default behavior you would like.

```ruby
class ApplicationForm < YAAF::Form
  # Customized behavior
end
```

### #initialize

The `.new` method should be called with the arguments that the form object needs.

When initializing a `YAAF` form object, there are two things to keep in mind
1. You need to define the `@models` instance variables to be an array of all the models that you want to be validated/saved within the form object.
2. To leverage `ActiveModel`'s features, you can call `super` to automatically make the attributes be stored in instance variables. If you use it, make sure to also add `attr_accessor`s, otherwise `ActiveModel` will fail.

### #valid?

The `.valid?` method will perform both the form object validations and the models validations. It will return `true` or `false` and store the errors in the form object.

By default `YAAF` form objects will store model errors in the form object under the same key. For example if a model has a `email` attribute that errored, the form object will provide the an error under the `email` key (e.g. `form_object.errors[:email]`).

### #invalid?

The `.invalid?` method is exactly the same as the `.valid?` method but will return the opposite boolean value.

### #errors

The `.errors` method will return an `ActiveModel::Errors` object such as any other `ActiveModel` model.

### #save

The `.save` method will run validations. If it's invalid it will return `false`, otherwise it will save all the models within a DB transaction and return `true`.

Defined callbacks will be called in the following order:
- `before_validation`
- `after_validation`
- `before_save`
- `after_save`
- `after_commit/after_rollback`

Options:
- If `validate: false` is send as options to the `save` call, it will skip validations.

### #save!

The `.save!` method is exactly the same as the `.save` method, just that if it is invalid it will raise an exception.

### Validations

`YAAF` form objects support validations the same way as `ActiveModel` models. For example:

```ruby
class RegistrationForm < YAAF::Form
  validates :email, presence: true
  validate :some_custom_validation

  # ...
end
```

### Callbacks

`YAAF` form objects support validations the same way as `ActiveModel` models. For example:

```ruby
class RegistrationForm < YAAF::Form
  before_validation :normalize_attributes
  after_commit :send_confirmation_email

  # ...
end
```

Available callbacks are:
- `before_validation`
- `after_validation`
- `before_save`
- `after_save`
- `after_commit/after_rollback`

## Links

- [7 Patterns to Refactor Fat ActiveRecord Models](https://codeclimate.com/blog/7-ways-to-decompose-fat-activerecord-models/)
- [ActiveModel Form Objects](https://thoughtbot.com/blog/activemodel-form-objects)
- [Form Objects Design Pattern](https://gorails.com/episodes/form-objects-design-pattern)
- [Form Object from Railscasts](https://makandracards.com/alexander-m/42271-form-object-from-railscasts)
- [Validating Form Objects](https://revs.runtime-revolution.com/validating-form-objects-8058fefc7b89)
- [Disciplined Rails: Form Object Techniques & Patterns — Part 1](https://medium.com/@jaryl/disciplined-rails-form-object-techniques-patterns-part-1-23cfffcaf429)
- [Complex form objects with Rails](https://www.codementor.io/@victor_hazbun/complex-form-objects-in-rails-qval6b8kt)

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rootstrap/yaaf. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/rootstrap/yaaf/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the YAAF project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/rootstrap/yaaf/blob/master/CODE_OF_CONDUCT.md).

## Credits

YAAF is maintained by [Rootstrap](http://www.rootstrap.com) with the help of our [contributors](https://github.com/rootstrap/yaaf/contributors).

[<img src="https://s3-us-west-1.amazonaws.com/rootstrap.com/img/rs.png" width="100"/>](http://www.rootstrap.com)
