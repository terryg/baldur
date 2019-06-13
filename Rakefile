# frozen_string_literal: true

require './init'

desc 'Default task: run all tests'
task default: [:test]

task :test do
  exec 'thor monk:test'
end

desc 'Creates the 300 width images for existing assets'
task :make_asset_300s do
  assets = Asset.all(deleted: false)
  assets.each do |asset|
    orig = MiniMagick::Image.open(asset.url)
    orig.resize('300x1000')
    orig.write('localcopy.jpg')

    value = (0...16).map { rand(97..122).chr }.join
    fkey = value + '.jpg'

    AWS::S3::S3Object.store(fkey, open('localcopy.jpg'), ENV['S3_BUCKET_NAME'])
    asset.update(s3_300: fkey)
    asset.save
  end
end

desc 'Creates the 500 width & thumb images for existing assets'
task :make_assets do
  assets = Asset.all(deleted: false)
  assets.each do |asset|
    orig = MiniMagick::Image.open(asset.url)
    orig.resize('500x2000')
    orig.write('localcopy.jpg')

    value = (0...16).map { rand(97..122).chr }.join
    fkey = value + '.jpg'

    AWS::S3::S3Object.store(fkey, open('localcopy.jpg'), ENV['S3_BUCKET_NAME'])
    asset.update(s3_500: fkey)
    asset.save

    orig.resize('150x1000')
    orig.write('localcopy.jpg')

    value = (0...16).map { rand(97..122).chr }.join
    fkey = value + '.jpg'

    AWS::S3::S3Object.store(fkey, open('localcopy.jpg'), ENV['S3_BUCKET_NAME'])
    asset.update(s3_thumb: fkey)
    asset.save
  end
end

namespace :assets do
  desc 'All active assets'
  task :all do
    Asset.all(deleted: false).each do |a|
      puts "#{a.id} - #{a.title} - #{a.series.name}"
    end
  end

end

namespace :series do
    desc 'All series'
    task :all do
      Series.all().each do |s|
        puts "#{s.id} - #{s.name}"
      end
    end
end

namespace :settings do
    desc 'All series'
    task :all do
      Settings.all().each do |s|
        puts "#{s.id} - #{s.name} - #{s.value}"
      end
    end
end