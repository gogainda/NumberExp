module Numbernote
  class ApiResource
    include HTTParty

    private

    def acceptable_response_code?
      (200...300).include? @response.code
    end
  end

  class LocalCallingGuideApi < ApiResource

    API_ENDPOINT = 'http://localcallingguide.com/xmlprefix.php'

    def initialize(options = {})
      @npa, @nxx = options[:npa], options[:nxx]
    end

    def do_api_lookup
      options = { query: { npa: @npa, nxx: @nxx } }
      @response = self.class.get API_ENDPOINT, options
    end

    def telco_info
      do_api_lookup
      if acceptable_response_code?
        return_response
      else
        nil
      end
    end

    private

    def return_response
      begin
        @response['root']['prefixdata']
      rescue => e
        Rails.logger.error 'LocalCallingGuide lookup failed'
        Rails.logger.error e.message
        Rails.logger.error e.backtrace.join("\n")
        nil
      end
    end
  end
end
