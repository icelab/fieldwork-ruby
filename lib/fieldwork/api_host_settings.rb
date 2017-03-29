module Fieldwork
  def self.api_host
    ENV['FIELDWORK_API_HOST'] || "api.dofieldwork.com"
  end

  def self.api_protocol
    ENV['FIELDWORK_API_PROTOCOL'] || "https"
  end

  def self.api_host_url
    "#{api_protocol}://#{api_host}"
  end
end
