![](http://techjeeper.com/wp-content/uploads/2013/08/Wordmark-Duo.png)

# DUO Auth 

This gem provides the ability to create & verify login requests & responses with the DUO 2-factor server.
The code is taken from https://github.com/duosecurity/duo_ruby with some minor refactorings and gemification.

## Compatibility
This gem is up-to-date with `bb77567c838d77bce4f501b475d28dade300edcd` from https://github.com/duosecurity/duo_ruby.
This covers `DUO-PSA-2015-001`.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'duo-auth'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install duo-auth

## Usage

### Create a Signed Request

To create a signed request to be passed to the DUO servers, use the follow class method:
```ruby
  Duo::Auth.sign_request(ENV[:duo_ikey], ENV[:duo_skey], Rails::Application.config.secret_token, @user.id)
```

The sign request method takes 4 arguments:

1. Your DUO Integration Key.
2. Your DUO Secret Key.
3. An application secret token. Any secret token with a minimum of 40 characters will do, but if you're using rails, the default secret token will work great.
4. Your user identifier. This is whatever you are using on DUO to track your users. This is also returned from the verify request step.

### Verify a DUO Response

To verify the returned DUO response after 2-factor has been complete, use the following:
```ruby
  Duo::Auth.verify_response(ENV[:duo_ikey], ENV[:duo_skey], Rails::Application.config.secret_token, params[:sig_response])
```
The verify response method takes 4 arguments:

1. Your DUO Integration Key.
2. Your DUO Secret Key.
3. An application secret token.
4. The response from DUO. This is typically posted back to your application after authentication is complete.

The `verify_response` method will return the user identifier that was passed to the `sign_request` method if the verification was successful.

## Contributing

1. Fork it ( https://github.com/TheKidCoder/duo-auth/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
