# frozen_string_literal: true

# Name-value pairs to configure things.
class Settings
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :value, String
end
