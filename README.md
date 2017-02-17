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

gem "token_auth", "~> 0.3.X"
```

Install it:

```
bundle
```

Install and run the migrations:

```
rails token_auth:install:migrations; rails db:migrate
```

Mount the Engine and make its routes available to the host application:

```ruby
# config/routes.rb

mount TokenAuth::Engine => "/token_auth"
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
      controller.cors_set_access_control_headers(allow_methods: "GET, OPTIONS")
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

## Sample Set up with Harmonium

This gem is often used in conjunction with
[harmonium-ts](https://github.com/NU-CBITS/harmonium-ts/). Below is some more
specific examples of set up to work with both.

Every two minutes by default, Harmonium transmits changed (dirty) resources to
the server and then polls the server for new or updated resources.

The server requires some configurations that allow for these `GET` and `POST` requests:

* Install the gem [token_auth_server_rails](https://github.com/NU-CBITS/token_auth_server_rails),
* Update [Participant callback](./examples/harmonium_configurations/participant_callbacks.rb),
* Update [Participant class](./examples/harmonium_configurations/participant.rb)
  , and
* Specify [syncable resources](./examples/harmonium_configurations/syncable_resources.rb)

On the server, each syncable class will need a `uuid` column. Add a before
validation such as [UuidCallbacks](./examples/harmonium_configurations/uuid_callbacks.rb)

```ruby
class Foo < ApplicationRecord
  before_validation UuidCallbacks

  validates :uuid, presence: true
  validates :uuid, uniqueness: true

  belongs_to :participant
end
```

You will also need to serialize the data. Specify what you need in the
`attributes` key and `id` key. An example is listed below.

```ruby
class FooSerializer < ActiveModel::Serializer
  attributes :uuid,
             :client_created_at,
             :client_updated_at,
             :bar

  attribute :uuid, key: :id

  def bar
    "hello world"
  end
end
```

These updates (adding the `uuid` column, serializing the data, and specifying
classes to the `pullable_resource_types` in
[Specify syncable resources](./examples/server_configurations/syncable_resources.rb))
will make these resources available for `GET` requests.

Example: `GET "/token_auth/api/payloads?filter[updated_at][gt]=DATETIME"`:

## Development

Clone the repository and install dependencies:

```
git clone git@github.com:NU-CBITS/token_auth_server_rails.git
bundle
```

Run the unit tests and linters for this Engine:

```
RAILS_ENV=test rails db:drop db:create db:migrate
rake
```
