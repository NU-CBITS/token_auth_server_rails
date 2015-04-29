# Token Authentication

This Rails Engine implements a simple configuration handshake with clients. It
also provides Controller Concerns for authenticating clients via an API.

## Installation

Add the gem to your Gemfile:

```ruby
# Gemfile

gem 'token_auth',
    git: 'https://github.com/cbitstech/token_auth_server_rails',
    tag: '0.0.1'
```

Install it:

```
bundle
```

Install and run the migrations:

```
rake token_auth:install:migrations; rake db:migrate
```

Mount the Engine and make its routes available to the host application:

```ruby
# config/routes.rb

mount TokenAuth::Engine => '/token_auth'
```

## Configuration

To customize the behavior of the token management functions, you can override
the `BaseController` class:

```ruby
# app/controllers/token_auth/base_controller.rb

module TokenAuth
  class BaseController < ApplicationController
    before_action :authenticate_user!
  end
end
```

To authenticate an API controller:

```ruby
# app/controllers/api/my_controller.rb

module Api
  class MyController < ActionController::Base
    include TokenAuth::Concerns::ApiResources

    after_action do |controller|
      controller.cors_set_access_control_headers(allow: "GET, OPTIONS")
    end

    def show
    end
  end
end
```

## Testing

After generating a configuration token, test authentication token generation:

```
curl --data "data[clientUuid]=asdf&configurationToken=4C3LM9" http://localhost:3000/token_auth/api/authentication_tokens
```
