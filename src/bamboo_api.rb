require 'uri'
require 'net/http'
require 'openssl'

class BambooApi
    def initialize(api_key)
        @api_key = api_key
        @base_url = 'https://api.bamboohr.com/api/gateway.php/browserstack/'
    end

    def get(url)
        url = URI(@base_url << url)

        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Get.new(url)
        request.basic_auth('51b173b2561d92e8efa344d6345f56f656300683', 'x')

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
