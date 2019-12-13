require 'sinatra'
require 'sinatra/cross_origin'
require 'json'
require 'yaml'
require_relative 'src/bamboo_api'
require_relative 'src/employee'
require_relative 'src/timezone_api'

class DCGlobalServer < Sinatra::Base
  API = ::BambooApi.new('51b173b2561d92e8efa344d6345f56f656300683')
  EMPLOYEE_IDS = YAML.load_file("#{File.dirname(__FILE__)}/config/employees.yml")
  DATACENTERS = YAML.load_file("#{File.dirname(__FILE__)}/config/datacenters.yml")
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

  get '/datacenters' do
    status 200
    datacenters = DATACENTERS.clone
    datacenters.each do |datacenter|
      datacenter['timezone'] = TimezoneApi.get_timezone(datacenter['latitude'], datacenter['longitude'])
    end
    datacenters.to_json
  end

  get '/getholidays' do
    status 200
    holiers = Holybops.new("b25eb172e18b9e38984010f6eeaf5efd0c1fe555")
    holiers.get_dates(params[:country_code], params[:year]).to_json
  end
end
