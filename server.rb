require 'sinatra'
require 'sinatra/cross_origin'
require 'json'
require 'yaml'
require_relative 'src/bamboo_api'
require_relative 'src/employee'

class DCGlobalServer < Sinatra::Base
  API = ::BambooApi.new('51b173b2561d92e8efa344d6345f56f656300683')
  EMPLOYEE_IDS = YAML.load_file("#{File.dirname(__FILE__)}/config/employees.yml")
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

  get '/employees' do
    status 200
    ::Employee.all(EMPLOYEE_IDS['ids'], API).to_json
  end
end
