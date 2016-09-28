require "faraday"
require "multi_json"
require "fieldwork/errors"

module Fieldwork
  class Client
    attr_reader :configuration

    def initialize(args={})
      @configuration = args.fetch(:configuration) {
        raise ConfigurationError, "No configuration provided to client instance"
      }
    end

    def track_event(event_name, event_properties={})
      ensure_configuration

      payload = {
        name: event_name,
        properties: event_properties
      }

      response = track_event_connection.post do |request|
        request.url track_event_endpoint_url
        request.headers['Content-Type'] = 'application/json'
        request.body = MultiJson.dump(payload)
      end

      case response.status
      when 200
        MultiJson.load(response.body, symbolize_keys: true)
      when 404
        raise ApiError, "#{response.status} endpoint not found: #{track_event_endpoint_url}"
      else
        error_message = begin
          response_json = MultiJson.load(response.body, symbolize_keys: true)

          if response_json[:status] == "error"
            response_json[:message]
          else
            response.body
          end
        rescue
          response.body
        end

        raise ApiError, error_message
      end
    end

    private

    def track_event_connection
      @track_event_connection ||= Faraday.new { |conn|
        conn.adapter(Faraday.default_adapter)
        conn.basic_auth(configuration.project_public_key, '')
      }
    end

    def track_event_endpoint_url
      @track_event_endpoint_url ||= "#{Fieldwork.api_host_url}/api/v1/projects/#{configuration.project_id}/events"
    end

    def ensure_configuration
      raise ConfigurationError, "client must be configured before use" unless configuration

      [:project_id, :project_public_key].each { |required_config_attribute|
        unless configuration.send(required_config_attribute)
          raise ConfigurationError, "Please configure a #{required_config_attribute} before tracking events"
        end
      }
    end
  end
end
