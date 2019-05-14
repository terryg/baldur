# frozen_string_literal: true

# An asset represents a single image.
class Asset
  include DataMapper::Resource

  property :id, Serial
  property :title, String
  property :year, String
  property :media, String
  property :width, Float
  property :height, Float
  property :s3_original, String
  property :s3_300, String
  property :s3_500, String
  property :s3_thumb, String
  property :weight, Integer
  property :deleted, Boolean, required: true, default: false
  property :sold, Boolean, required: true, default: false

  belongs_to :series

  attr_accessor :temp_filename

  def s3_bucket
    'http://s3.amazonaws.com/' + ENV['S3_BUCKET_NAME'] + '/'
  end

  def url
    s3_bucket + s3_original if s3_original
  end

  def url_500
    s3_bucket + s3_500 if s3_500
  end

  def url_300
    s3_bucket + s3_300 if s3_300
  end

  def url_thumb
    s3_bucket + s3_thumb if s3_thumb
  end

  def short_description_text
    format('%<title>s. %<height_in>dx%<width_in>d. %<year>s')
  end

  def sold_string
    sold ? 'SOLD' : ''
  end

  def alt_text
    o = title
    o << '. '
    o << dim
    o << '. '
    o << media
    o << '. '
    o << year
    o << '. '
    o << sold_string
  end

  def title_html
    format('<em>%<title>s</em>')
  end

  def text_html
    o = title_html
    o << ', '
    o << year
    o << '. '
    o << media
    o << '. '
    o << dim
    o << '. '
    o << sold_string
  end

  def title_year_html
    format('<em>%<title>s</em>, %<year>s.')
  end

  def dim
    format('%<height_in>d x %<width_in>d inches')
  end

  def width_in
    if width.nil?
      0
    else
      width / 25.4
    end
  end

  def height_in
    if height.nil?
      0
    else
      height / 25.4
    end
  end

  def price
    20 * (width_in + height_in)
  end

  def price_text
    "$#{format('%.0f', price)}"
  end
end
