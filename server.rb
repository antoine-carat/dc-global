require 'sinatra'
require 'sinatra/cross_origin'
require 'json'
require 'yaml'
require 'open-uri'

require_relative 'src/bamboo_api'
require_relative 'src/employee'
require_relative 'src/timezone_api'

class DCGlobalServer < Sinatra::Base
  API = ::BambooApi.new('51b173b2561d92e8efa344d6345f56f656300683') #TODO: Replace this personal key by company key
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

  # TODO Pass employee_ids as a param
  get '/employees' do
    status 200
    employee_ids = []
    DATACENTERS.each do |dc|
      dc['engineers'].each { |eng| employee_ids.push(eng) }
    end
    employees = ::Employee.all(employee_ids, API)

    # Download picture if file not there.
    employees.each do | e |
      filename = "public/#{e.last_name}.jpg"
      next if File.exist? filename

      puts "Downloading #{filename}"
      File.open("public/#{e.last_name}.jpg", 'wb') do |fo|
        fo.write open(e.photo_url).read 
      end
    end
    employees.to_json
  end

  get '/datacenters' do
    status 200
    datacenters = DATACENTERS.clone
    datacenters.each do |datacenter|
      datacenter['timezone'] = TimezoneApi.get_timezone(datacenter['latitude'], datacenter['longitude'])
    end
    datacenters.to_json
  end
end
