require "icelab_crm/version"
require "icelab_crm/configuration"
require "icelab_crm/client"

module IcelabCrm
  def self.configuration
    @configuration
  end

  def self.configuration=(config)
    @configuration = config
  end

  def self.configure
    @configuration ||= Configuration.new
    yield configuration
  end

  def self.track_event(event_name, event_properties={})
    Client.new(configuration: configuration).track_event(
      event_name, event_properties
    )
  end

  def self.client(client_config=nil)
    instance_config = if client_config
      client_config
    else
      configuration
    end

    Client.new(configuration: instance_config)
  end
end
