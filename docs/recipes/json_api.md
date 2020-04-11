# Using YAAF with nested forms

When you are using Rails as a JSON API, you can still use `YAAF` to build your models.

## Usage

You probably won't need the `new` or `edit` endpoints but you'll still need the `create` and `update` ones. There you can use form objects to encapsulate object building logic. 

For example, a bulk invites form will look like this:

```ruby
# app/forms/api/v1/bulk_invites_form.rb

module Api
  module V1
    class BulkInvitesForm < ApplicationForm
      attr_accessor :invites_params
      validate :amount_of_invites

      def initialize(args = {})
        super(args)

        @models = [invites].flatten
      end

      private

      def invites
        @invites ||= invites_params&.dig(:invites)&.map { |invite_params| Api::V1::InviteForm.new(invite_params) } || []
      end

      def amount_of_invites
        return if invites.size.between?(1, 5)

        errors[:base] << 'You need to send between one and five invites'
      end
    end
  end
end
```

```ruby
# app/forms/api/v1/invite_form.rb

module Api
  module V1
    class InviteForm < ApplicationForm
      attr_accessor :email
      validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
     
      def initialize(args = {})
        super(args)
     
        @models = [invite]
      end
     
      private
     
      def invite
        @invite ||= Invite.new(invited_user_email: email)
      end
    end
  end
end
```

```ruby
# app/controllers/api/v1/invites_controller.rb

module Api
  module V1
    class InvitesController < ApplicationController
      skip_before_action :verify_authenticity_token

      def create
        @form = Api::V1::BulkInvitesForm.new(invites_params: invites_params)

        if @form.save
          render json: {}, status: :created
        else
          render json: {
            errors: Api::V1::ErrorsSerializer.new(@form).serialize
          }, status: :unprocessable_entity
        end
      end

      private

      def invites_params
        params.permit(invites: [:email])
      end
    end
  end
end
```

```rb
# app/serializers/api/v1/errors_serializer.rb

module Api
  module V1
    class ErrorsSerializer
      attr_reader :object

      def initialize(object)
        @object = object
      end

      def serialize
        object.errors.to_h.map { |message| { detail: message } }
      end
    end
  end
end
```

## Try it out!
Successful request
```curl
curl --header "Content-Type: application/json" --data '{"invites":[{ "email": "test@example.com" }]}'  https://yaaf-examples.herokuapp.com/api/v1/invites
```

Error request
```curl
curl --header "Content-Type: application/json" --data '{"invites":[{ "email": "xyz" }]}'  https://yaaf-examples.herokuapp.com/api/v1/invites
```

## Got questions?

Feel free to [create an issue](https://github.com/rootstrap/yaaf/issues) and we'll discuss about it.

YAAF is maintained by [Rootstrap](http://www.rootstrap.com) with the help of our [contributors](https://github.com/rootstrap/yaaf/contributors).

[![YAAF](../images/footer.png)](http://www.rootstrap.com)
