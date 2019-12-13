require 'uri'
require 'net/http'
require 'openssl'
require 'json'

class Holybops
    def initialize(api_key)
        @api_key = api_key
        @base_url = "https://calendarific.com/api/v2/holidays?&api_key=#{@api_key}"
        puts @base_url
    end

    def get_dates(country_code, year)
      json = get_json("&country=#{country_code}&year=#{year}")
      national_holidays = json["response"]["holidays"].select do |holiday|
        holiday["type"] == ['National holiday'] || holiday["type"] == ['Observance']
      end

      dates = []
      national_holidays.each do |holiday|
        dates.push(holiday['date']['iso'])
      end
      dates
    end

    def get_json(params)
        url = URI(@base_url + params)
        response = Net::HTTP.get_response(url)
        JSON.parse(response.read_body)
    end
end
