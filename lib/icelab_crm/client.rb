module IcelabCrm
  class Client
    attr_reader :configuration

    def initialize(args={})
      @configuration = args.fetch(:configuration) { raise "No configuration provided to client instance" }
    end

    def track_event(event_name, event_properties={})
      ensure_configuration

      # track the event...
    end

    private

    def ensure_configuration
      raise "#{self.class} must be configured before use" unless configuration

      [:project_id, :project_public_key].each { |required_config_attribute|
        unless configuration.send(required_config_attribute)
          raise "Please configure a #{required_config_attribute} before tracking events"
        end
      }
    end
  end
end
