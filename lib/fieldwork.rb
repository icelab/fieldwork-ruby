require "fieldwork/version"
require "fieldwork/api_host_settings"
require "fieldwork/errors"
require "fieldwork/configuration"
require "fieldwork/client"

module Fieldwork
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
