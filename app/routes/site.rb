class Main
  get "/" do
    @redis = monk_settings(:redis)
    haml :home
  end

  get "/series/:id" do
    @name = params[:id].upcase
    @assets = Asset.all('series.name' => @name)
    haml :series
  end

  get "/works/:id" do
    @name = params[:id]
    @assets = Asset.all('year' => @name)
    haml :series
  end

  get "/oysters" do
    haml :oysters
  end

  get "/CV" do
    haml :cv
  end

  get "/contact" do
    haml :contact
  end

  get "/upload" do
    haml :upload
  end

  post "/upload" do
    if params['password'] == 'karlfardman'
      filename = params['myfile'][:filename]

      s3_filename = store_on_s3(params['myfile'][:tempfile], filename)

      series = Series.first_or_create(:name => params[:series])
      Asset.create(:title => params[:title],
                   :year => params[:year],
                   :media => params[:media],
                   :width => params[:width].to_i*25.4,
                   :height => params[:height].to_i*25.4,
                   :s3_filename => s3_filename,
                   :series_id => series.id)
    end

    haml :upload
  end
end
