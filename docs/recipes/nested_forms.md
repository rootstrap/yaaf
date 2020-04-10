# Using YAAF with nested forms

When you need to create/update a collection of models you can use nested forms.

## Usage

Add the nested form objects to the `@models` of the base one. To render the form using Rails helpers you might need to define an `attr_accessor` for the collection.

For example, a bulk invites form will look like this:

```ruby
# app/forms/bulk_invites_form.rb

class BulkInvitesForm < ApplicationForm
  # invites_attributes is needed in order to use the
  # fields_for helper with a collection
  attr_accessor :invites_params, :invites_attributes
  validate :amount_of_invites

  def initialize(args = {})
    super(args)

    @models = [filled_invites].flatten
  end

  def invites
    @invites ||= Array.new(5) do |i|
      InviteForm.new(
        invites_params&.dig(:invites_attributes, i.to_s)
      )
    end
  end

  private

  def filled_invites
    @filled_invites ||= invites.select { |invite| invite.email.present? }
  end

  def amount_of_invites
    return if filled_invites.size.between?(1, 5)

    errors[:base] << 'You need to send between one and five invites'
  end
end
```

```ruby
# app/forms/invite_form.rb

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
```

```ruby
# app/controllers/invites_controller.rb

class InvitesController < ApplicationController
  def new
    @form = BulkInvitesForm.new
  end

  def create
    @form = BulkInvitesForm.new(invites_params: invites_params)

    if @form.save
      flash[:success] = 'Invites have been sent successfully'
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def invites_params
    params.require(:bulk_invites_form).permit(invites_attributes: [:email])
  end
end
```

```erb
# app/views/invites/new.rb

<%= simple_form_for(@form, url: invites_path) do |f| %>
  <%= f.error_notification %>

  <% f.object.errors.messages[:base].each do |message| %>
    <li><%= message %></li>
  <% end %>

  <div class="form-inputs">
    <%= f.simple_fields_for :invites do |ff| %>
      <%= ff.input :email %>
    <% end %>
  </div>

  <div class="form-actions">
    <%= f.submit 'Send invites' %>
  </div>
<% end %>
```

## Got questions?

Feel free to [create an issue](https://github.com/rootstrap/yaaf/issues) and we'll discuss about it.

YAAF is maintained by [Rootstrap](http://www.rootstrap.com) with the help of our [contributors](https://github.com/rootstrap/yaaf/contributors).

[![YAAF](../images/footer.png)](http://www.rootstrap.com)
