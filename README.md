# Token Authentication

This Rails Engine implements a simple configuration handshake with clients. It
also provides Controller Concerns for authenticating clients via an API.

## Overview

The basic workflow is as follows:

1. A user generates a Configuration Token within your host application tied to
   an "entity" within the application. This entity will likely represent a human
   user.
1. The Configuration Token is shared with the client you wish to authorize.
1. If the Configuration Token is transmitted along with a unique client
   identifier while the Token is still valid, the Configuration Token will be
   destroyed and an Authentication Token will be created and returned to the
   client.
1. The Authentication Token can be used to authenticate subsequent requests, as
   long as it is accompanied by the unique client identifier.
1. The Authentication Token can be disabled temporarily or permanently, and it
   can be destroyed. If it is destroyed, this process must be repeated.

## Installation

Add the gem to your Gemfile:

```ruby
# Gemfile

gem 'token_auth',
    git: 'https://github.com/cbitstech/token_auth_server_rails',
    tag: '0.0.3'
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

## Development

Clone the repository and install dependencies:

```
git clone git@github.com:cbitstech/token_auth_server_rails.git
bundle
```

Run the unit tests and linters for this Engine:

```
RAILS_ENV=test bin/rake db:create db:migrate
bin/rake
```
