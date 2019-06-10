# frozen_string_literal: true

require 'sinatra'
require 'logger'
require 'sass'

require './helpers'

# The app class
class App < Sinatra::Base
  use Rack::Session::Cookie, key: 'rack.session', secret: ENV['RACK_SECRET']
  enable :methodoverride
  helpers Helpers

  set :logging, Logger::DEBUG

  get '/gallery' do
    @series = Series.all(order: :id.desc)
    haml :gallery
  end

  get '/slideshow' do
    @assets = Asset.all(:deleted.not => TRUE, :order => :weight.asc)
    haml :slideshow
  end

  get '/pricelist' do
    @assets = Asset.all(:deleted.not => TRUE,
                        :sold.not => TRUE,
                        :order => :weight.asc)
    haml :pricelist
  end

  get '/' do
    @home = '1'
    @full_url = 'http://www.laramirandagoodman.com'
    @series = Series.all(order: :id.desc)
    @assets = Asset.all(deleted: false)
    haml :home
  end

  get '/css/:stylesheet.css' do
    content_type 'text/css', charset: 'UTF-8'
    sass :"css/#{params[:stylesheet]}"
  end

  get '/paintings' do
    @uri = 'paintings'
    @assets = Asset.all(deleted: false, order: [:weight.asc])
    haml :paintings, active: 'paintings'
  end

  get '/CV' do
    @assets = []
    haml :cv
  end

  get '/contact' do
    @assets = []
    @address = 'artist@laramirandagoodman.com'
    haml :contact
  end

  get '/upload' do
    @assets = []
    haml :upload
  end

  post '/upload' do
    if params['password'] == ENV['UPLOAD_PASSWORD']
      series = Series.first_or_create(name: params[:series])
      heaviest = Asset.first(deleted: false, order: [:weight.desc])
      weight = heaviest.weight unless heaviest.nil?
      weight ||= 0

      asset = Asset.create(title: params[:title],
                           year: params[:year],
                           media: params[:media],
                           width: params[:width].to_i * 25.4,
                           height: params[:height].to_i * 25.4,
                           series_id: series.id,
                           weight: weight + 10)

      asset.s3_original = store_on_s3(params['myfile'][:tempfile],
                                      params['myfile'][:filename])
      asset.save
    end

    haml :upload
  end
end

require './routes/assets'
