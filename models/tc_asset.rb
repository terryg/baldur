# frozen_string_literal: true

require 'dm-core'

require_relative 'asset'
require_relative 'series'

DataMapper.setup(:default, ENV['DATABASE_URL'])

DataMapper.finalize

require 'test/unit'

# Test cases for the asset model.
class TestAsset < Test::Unit::TestCase
  def setup
    @series = Series.create({
      name: 'TESTS'
    })

    @title = 'After Rome'
    @year = 2015
    @media = 'Oil on canvas'
    @width = 304.8
    @height = 228.6

    @asset = Asset.new({
      title: @title,
      year: @year,
      media: @media,
      width: @width,
      height: @height,
      series_id: @series.id,
      deleted: false,
      sold: true
    })
  end

  def teardown
    @asset.destroy
    @series.destroy
  end

  def test_asset_save
    assert_equal(true, @asset.save)
    assert_not_equal(nil, @asset.id)
  end

  def test_asset_title
    assert_equal(@title, @asset.title)
  end

  def test_asset_alt_text
    assert_equal(52, @asset.alt_text.length)
    assert_equal(52, @asset.alt_text.length)
  end

  def test_asset_destroy
    @asset.save

    doomed = Asset.get(@asset.id)

    assert_equal(true, doomed.destroy)

    check = Asset.get(@asset.id)

    assert_equal(nil, check)
  end

end