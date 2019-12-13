require 'sinatra'
require 'sinatra/cross_origin'
require 'json'

class DCGlobalServer < Sinatra::Base
  set :bind, '0.0.0.0'

  configure do
    enable :cross_origin
  end

  before do
    response.headers['Access-Control-Allow-Origin'] = '*'
  end

  get '/' do
    status 200
    File.read(File.join('public', 'index.html'))
  end

end