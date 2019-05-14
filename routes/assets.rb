# frozen_string_literal: true

# Asset routes
class Assets < App
  get '/assets/:id' do
    @asset = Asset.get(params[:id].to_i)
    redirect '/assets' if @asset.nil?
    @full_url = "http://www.laramirandagoodman.com/paintings/view/#{@asset.id}"
    assets = Asset.all(deleted: false, order: [:weight.asc])
    assets.each_with_index do |a, index|
      next unless a.id == @asset.id

      @prev_id = assets[index - 1].id if index.positive? && assets[index - 1]

      if (index < assets.size) && assets[index + 1]
        @next_id = assets[index + 1].id
      end
    end

    if params[:edit] == 'on'
      @series = Series.all(order: :name.desc)
      haml :asset_form
    else
      haml :asset
    end
  end

  post '/assets/:id' do
    asset = Asset.get(params[:id].to_i)
    asset.update_from_form(params)
    redirect "/assets/#{params[:id]}", 301
  end
end
