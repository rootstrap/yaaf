# Using YAAF with Simple Form

[Simple Form](https://github.com/heartcombo/simple_form) is a gem to create visual forms in an easy and flexible manner.

## Usage

Pass a `YAAF::Form` object instance to the `simple_form_for` helper method.

For example, in a library management system (a pretty miminal one), the form to create books will look like this:

```ruby
# app/forms/book_form.rb

class BookForm < YAAF::Form
  attr_accessor :name, :isbn

  def initialize(attributes)
    super(attributes)

    @models = [book]
  end

  def book
    @book ||= Book.new(name: name, isbn: isbn)
  end
end
```


```ruby
# app/controllers/books_controller.rb

class BooksController < ApplicationController
  def new
    @book = BookForm.new
  end
end
```

```erb
<%# app/views/books/new.html.erb %>

<%= simple_form_for(@book, method: :post, url: books_path) do |f| %>
  <%= f.input :name %>
  <%= f.input :isbn %>

  <%= f.submit 'Create Book' %>
<% end %>
```

## I18n

In order to make use of translations correctly, we should pass an `as` value to the `simple_form_for` helper method.

```erb
<%# app/views/books/new.html.erb %>

<%= simple_form_for(@book, as: :book, ...) do |f| %>
  ...
```

So you now can write your translations as:

```yaml
# app/config/locales/simple_form.en.yml

en:
  simple_form:
    ...

    labels:
      book:
        name: Book Name
        isbn: International Standard Book Number
```

When using the `f.submit` helper method from Simple Form, the method `model_name` will be used to display the
button's text. If this is not defined it will display: "Create Book Form".
You can use a translation directly in the view to avoid overriding this method.

```ruby
# app/forms/book_form.rb

  ...

  def model_name
    Book.model_name
  end

  ...
```

More info about how Simple Form translates forms [here](https://github.com/heartcombo/simple_form#i18n).

## Persisted?

Define the `persisted?` method in your form object to let Simple Form know if the object is being created or upated.

```ruby
# app/forms/book_form.rb

  ...

  def persisted?
    book.persisted? # Or you can directly make it return false
  end

  ...
```

## Got questions?

Feel free to [create an issue](https://github.com/rootstrap/yaaf/issues) and we'll discuss about it.

YAAF is maintained by [Rootstrap](http://www.rootstrap.com) with the help of our [contributors](https://github.com/rootstrap/yaaf/contributors).

[![YAAF](../images/footer.png)](http://www.rootstrap.com)
