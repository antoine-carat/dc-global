require 'uri'
require 'net/http'
require 'json'
require 'date'

module TimezoneApi
    API_KEY='8OUQAX768WLN'
    CACHE = {}

    def self.get_timezone(lat, lng)
        url = URI('http://api.timezonedb.com/v2.1/get-time-zone')
        params = { key: API_KEY, by: 'position', lat: lat, lng: lng, format: 'json' }
        url.query = URI.encode_www_form(params)

        cached_resp = CACHE["#{lat},#{lng}"]
        if cached_resp && cached_resp[:date] <= Date.today
            return cached_resp[:result]
        end

        http = Net::HTTP.new(url.host, url.port)

        request = Net::HTTP::Get.new(url)

        response = http.request(request)
        json_resp = JSON.parse(response.read_body)
        CACHE["#{lat},#{lng}"] = { result: json_resp, date: Date.today }
        json_resp
    end
end