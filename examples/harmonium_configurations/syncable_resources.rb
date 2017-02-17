# frozen_string_literal: true
# Specify which resources can by pushed, pulled, or both by a client.
Rails.configuration.pushable_resource_types = %w(Foo)
Rails.configuration.pullable_resource_types = %w(
  Bar
  Blog
)
