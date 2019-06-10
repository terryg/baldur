# frozen_string_literal: true

require 'rubygems'

require 'haml'
require 'sass'
require 'logger'
require 'dm-core'
require 'dm-validations'
require 'dm-migrations'
require 'dm-chunked_query'
require 'aws/s3'
require 'mini_magick'

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, (ENV['DATABASE_URL'] ||
                             'postgres://localhost/baldur_development'))

require './models/asset'
require './models/series'
require './models/settings'
                             
DataMapper.finalize
                             
AWS::S3::Base.establish_connection!(
  access_key_id: ENV['AWS_ACCESS_KEY_ID'],
  secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
)
