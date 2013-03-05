class Asset
  include DataMapper::Resource

  property :id, Serial
  property :title, String
  property :year, String
  property :media, String
  property :width, Float
  property :height, Float
  property :s3_filename, String

  belongs_to :series

  attr_accessor :temp_filename

  def store_on_s3(temp_file, filename)
    value = (0...32).map{(65+rand(26)).chr}.join
    ext = File.extname(filename)
    fkey = value  + ext
    fname = 'public/uploads/' + fkey
    File.open(fname, "w") do |f|
      f.write(temp_file.read)
    end

#    image = Magick::Image::read(fname).first      
#    image.resize_to_fit!(500)
#    image.write(fname)
#    image.destroy!
      
    AWS::S3::S3Object.store(fkey, open(fname), ENV['S3_BUCKET_NAME'])
      
    update(:s3_filename => fkey) 
  end

  def url
    'http://s3.amazonaws.com/' + ENV['S3_BUCKET_NAME'] + '/' + s3_filename
  end

  def alt_text
    "%s. %.1fx%.1f. %s. %s." % [title, height_in, width_in, media, year]
  end

  def text_html
    "<em>%s</em>, %s. %s. %.1f x %.1f inches" % [title, year, media, height_in, width_in]
  end

  def width_in
    width / 25.4
  end

  def height_in
    height / 25.4
  end

end


