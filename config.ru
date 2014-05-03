# encoding: UTF-8
require './app.rb'
require 'dotenv'
require 'less'
require 'mumblr'

class BoxWino
  configure do
    set :site_name, "Box Wino"
    set :google_analytics_code, "UA-37335957-3"
    set :site_host, "boxwino.com"
  end
end
Mumblr.configure do |config|
  config.mongomapper     = "mongomapper://localhost:27017/boxwino-#{settings.environment}"
  config.include_private = true
  config.default_blog    = 'outofboxwine'
end

run BoxWino
