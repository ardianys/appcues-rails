# Appcues Rails Gem

The easiest way to install Appcues in a rails app.

For interacting with the Appcues REST API, use the `appcues` gem (https://github.com/appcues/appcues-ruby)

## Installation
Add this to your Gemfile:

```ruby
gem "appcues-rails"
```

Then run:

```
bundle install
```

Take note of your `appcues_id` from [here](https://my.appcues.com/account) and generate a config file:

```
rails generate appcues:config YOUR-APPCUES-ID
```

To make installing Appcues as easy as possible, where possible a `<script>` tag **will be automatically inserted before the closing `</body>` tag**. For most Rails apps, **you won't need to do any extra config**. Having trouble? Check out troubleshooting below.

### Disabling automatic insertion

To disable automatic insertion for a particular controller or action you can:

```ruby
  skip_after_filter :appcues_rails_auto_include
```

### Troubleshooting
If it's not working make sure:

* You've generated a config file with your `appcues_id` as detailed above.
* Your user object responds to an `id` and `email` method.
* Your current user is accessible in your controllers as `current_user` or `@user`, if not in `config/initializers/appcues.rb`:

```ruby
  config.user.current = Proc.new { current_user_object }
```

Feel free to mail us: folks@appcues.com, if you're still having trouble.

## Configuration

### User Custom data attributes
You can associate any attributes, specific to your app, with a user in Appcues.

For custom data attributes you want updated on every request set them in `config/initializers/appcues.rb`, the latest value will be sent to Appcues on each page visit.

Configure what attributes will be sent using either a:

  * `Proc` which will be passed the current user object
  * Or, a method which will be sent to the current user object

e.g.

```ruby
  config.user.custom_data = {
    :plan => Proc.new { |user| user.plan.name },
    :is_paid => Proc.new { |user| user.plan.present? },
    :email_verified => :email_verified?
  }
```

In some situations you'll want to set some custom data attribute specific to a request.

You can do this using the `appcues_custom_data` helper available in your controllers:

```ruby
class AppsController < ActionController::Base
  def activate
    appcues_custom_data.user[:app_activated_at] = Time.now
    ...
  end

  def destroy
    appcues_custom_data.user[:app_deleted_at] = Time.now
    ...
  end
end
```

Attributes must be accessible in order to sync with appcues.
Additionally, attributes ending in "_at" will be parsed as times.


### Environments

By default Appcues will be automatically inserted in development and production Rails environments. If you would like to specify the environments in which Appcues should be inserted, you can do so as follows:

```ruby
  config.enabled_environments = ["production"]
```

### Manually Inserting the Appcues Javascript

Some situations may require manually inserting the Appcues script tag. If you simply wish to place the Appcues javascript in a different place within the page or, on a page without a closing `</body>` tag:

```erb
  <%= appcues_script_tag %>
```

This will behave exactly the same as the default auto-install. If for whatever reason you can't use auto-install, you can also provide a hash of user data as the first argument:

```erb
<% if logged_in? %>
  <%= appcues_script_tag({
    :appcues_id => 'your-appcues-id',
    :user_id => current_user.id,
    :email => current_user.email,
    :name => current_user.name,
    :created_at => current_user.created_at,
    :custom_data => {
      'plan' => current_user.plan.name
    }
  }) %>
<% end %>
```


## Running tests/specs

specs should run on a clean clone of this repo, using the following commands. (developed against ruby 2.1.2 and 1.9.3)

```
bundle install
bundle exec rake spec
or
bundle exec rspec spec/
```
