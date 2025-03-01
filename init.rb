# frozen_string_literal: true

require 'rubygems'

require 'aws/s3'
require 'haml'
require 'logger'
require 'mini_magick'
require 'rom'
require 'rom-sql'
require 'sass'
require 'sinatra'

Dir.glob('./baldur/**/*.rb').sort.each do |f|
  require f
end

AWS::S3::Base.establish_connection!(
  access_key_id: ENV['AWS_ACCESS_KEY_ID'],
  secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
)

configuration = ROM::Configuration.new(:sql, ENV['DATABASE_URL'])
configuration.register_relation(Assets, Series, Settings)

MAIN_CONTAINER = ROM.container(configuration)
