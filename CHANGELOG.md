# Changelog

## 0.3.2 - 2017-03-17
* Add `pre_content` and `post_content` `content_for` tags on the token
  configuration page

## 0.3.1 - 2017-01-09

* Fix error in inclusion of Concerns::CorsSettings
* stop using deprecated `each_with_object` method

## 0.3.0.beta2 - 2016-07-27

* satisfy most Rails 5 deprecations

## 0.3.0.beta1 - 2016-05-06

* update to Rails 5
* update Travis config
* fix Rails 5 compatibility
* ignore byebug files
* test against byebug files

## 0.2.5 - 2016-04-13

* modify translation for config token

## 0.2.4 - 2016-03-23

* add translations for "disabled"

## 0.2.3 - 2016-03-23

* add all translations

## 0.2.2 - 2016-03-18

* enable filter by updated_at lower bound

## 0.2.1 - 2016-03-15

* add English translations

## 0.2.0 - 2016-03-15

* translate view text
* bump requirement to Rails 4.2.6
* test with Ruby 2.3.0 and latest rubocop
* use RVM Ruby 2.3.0

## 0.1.3 - 2016-02-18

* allow for config token valid period to be modified

## 0.1.2 - 2016-01-22

* ensure CORS headers are set on 401 responses
* rewrite serialization and errors to work with AMS

## 0.1.1 - 2016-01-17

* configure with latest RuboCop and fix

## 0.1.0 - 2016-01-17

* modify Payloads API to work with client lib
* add OPTIONS action for clients that require it
* allow for config tokens with extra whitespace
* ensure proper version of AMS is used
* implement payload synchronization api

## 0.0.4 - 2015-07-01

* relax Rails version dependency

## 0.0.3 - 2015-05-26

* fix display of expired Configuration Tokens
* allow destroying config tokens without exceptions

## 0.0.2 - 2015-05-01

* renamed "participant" to "entity"; updated README
* optionally print value for entity provided by host

## 0.0.1 - 2015-04-29

* initial release
