require 'uri'
require 'net/http'
require 'openssl'
require 'json'

module TimezoneApi
    API_KEY='8OUQAX768WLN'

    def self.get_timezone(lat, lng)
        url = URI('http://api.timezonedb.com/v2.1/get-time-zone')
        params = { key: API_KEY, by: 'position', lat: lat, lng: lng, format: 'json' }
        url.query = URI.encode_www_form(params)

        http = Net::HTTP.new(url.host, url.port)
        # http.use_ssl = true
        # http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Get.new(url)

        response = http.request(request)
        JSON.parse(response.read_body)
    end
end