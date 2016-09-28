module Fieldwork
  def self.api_host
    ENV['FIELDWORK_API_HOST'] || "localhost:3000"
  end

  def self.api_protocol
    ENV['FIELDWORK_API_PROTOCOL'] || "http"
  end

  def self.api_host_url
    "#{api_protocol}://#{api_host}"
  end
end
