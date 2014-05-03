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

  get '/reset' do
    5.times do |page|
      Mumblr::Post.all!(offset: page * 20)
    end
    redirect to('/')
  end

  get '/why' do
    @why_box_wine = Mumblr::TextPost.tagged('why box wine').sort(:timestamp.asc)

    erb :why , locals: { why_box_wine: @why_box_wine }
  end

  get '/wine' do
    redirect to('/wines')
  end

  get '/wines' do
    @wine_features = Mumblr::PhotosetPost.tagged('wine_feature').sort(:timestamp.asc)

    erb :wines , locals: { wine_features: @wine_features }
  end

  get '/where' do
    @wheres = Mumblr::TextPost.tagged('where_to_buy').sort(:timestamp.asc).first

    erb :where , locals: { wheres: @wheres }
  end

  get '/' do
    @welcome_message = Mumblr::TextPost.tagged('welcome_message').sort(:timestamp.asc).first
    erb :index , locals: { welcome_message: @welcome_message }
  end
end
