require 'uri'
require 'net/http'
require 'openssl'

class BambooApi
    def initialize(api_key)
        @api_key = api_key
        @base_url = 'https://api.bamboohr.com/api/gateway.php/browserstack/v1/employees/directory'
    end

    def get(url)
        url = URI(@base_url << url)

        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Get.new(url)

        response = http.request(request)
        Nokogiri::XML(response.read_body)
    end

    def get_employees()
        get("v1/employees/directory")
    end

    def get_time_off()
        get("v1/time_off/whos_out/")
    end
end
