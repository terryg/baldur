# frozen_string_literal: true

# A series is a collection of assets.
class Series
  include DataMapper::Resource

  property :id, Serial
  property :name, String
  property :description, Text

  has n, :assets
end
