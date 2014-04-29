#!/usr/bin/env ruby
# encoding: UTF-8
# run with the command 'rackup'
require 'sinatra/base'
require 'sinatra/assetpack'
require 'less'

class BoxWino < Sinatra::Base
  set :root, File.dirname(__FILE__) # You must set app root
  configure do
    set :site_name, "Box Wino"
    set :google_analytics_code, "UA-37335957-3"
    set :site_host, "boxwino.com"
  end

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

  get '/' do
    erb :index
  end
end
