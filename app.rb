#!/usr/bin/env ruby
# encoding: UTF-8
# run with the command 'rackup'
require 'sinatra/base'
require 'sinatra/assetpack'

class BoxWino < Sinatra::Base
  set :root, File.dirname(__FILE__) # You must set app root

  register Sinatra::AssetPack

  assets {
    serve '/js',     from: 'assets/js'        # Default
    serve '/css',    from: 'assets/css'       # Default
    serve '/fonts',  from: 'assets/fonts'     # Default
    serve '/images', from: 'assets/images'    # Default

    # The second parameter defines where the compressed version will be served.
    # (Note: that parameter is optional, AssetPack will figure it out.)
    # The final parameter is an array of glob patterns defining the contents
    # of the package (as matched on the public URIs, not the filesystem)
    js :app, '/js/app.js', [
      '/js/vendor/**/*.js',
      '/js/lib/**/*.js'
    ]

    css :application, '/css/application.css', [
      '/css/app.css',
    ]

    js_compression  :jsmin
    css_compression :simple
  }

  #set defaults for the layout
  before do
    @page = Hash.new
    @page['title']       = "Box Wino" #settings.site_name
    @page['keywords']    = ["box wine", "alcohol", "wine", "affordable"]
    @page['description'] = "For the love of the box wine."
  end

  get '/reset' do
    5.times do |page|
      Mumblr::Post.all!(offset: page * 20)
    end
    redirect to('/')
  end

  get '/why' do
    @page['title']       = "Why Box Wine?"
    @page['description'] = "Box wine isn't just for college anymore. Box wine is cheap, efficient, last a long time, and is delicious."
    @page['keywords']   << ["green", "eco-friendly", "efficient"]

    why_box_wine = Mumblr::TextPost.tagged('why box wine').sort(:timestamp.asc)

    erb :why , locals: { why_box_wine: why_box_wine }
  end

  get '/wine' do
    redirect to('/wines')
  end

  get '/wines' do
    @page['title']       = "The Best Box Wines"
    @page['description'] = "Here are some of our favorite box wines. We drink any box we can get our hands on, so you only need to try the best."
    @page['keywords']   << ["reviews", "ratings", "somelier"]

    wine_features = Mumblr::PhotosetPost.tagged('wine_feature').sort(:timestamp.asc)
    wine_features.each do |wine|
      @page['keywords'] << wine.tags.select{|tag| tag =~ /^[^_]+$/}
    end

    erb :wines , locals: { wine_features: wine_features }
  end

  get '/where' do
    @page['title']     = "Where to buy Box Wine"
    @page['keywords'] << ["shopping", "e-commerce"]

    wheres = Mumblr::TextPost.tagged('where_to_buy').sort(:timestamp.asc)

    erb :where , locals: { wheres: wheres }
  end

  get '/' do
    @page['title'] = "Box Wino, or: How to stop spending a fortune and love the box"

    welcome_message = Mumblr::TextPost.tagged('welcome_message').sort(:timestamp.asc).first
    erb :index , locals: { welcome_message: welcome_message }
  end
end
