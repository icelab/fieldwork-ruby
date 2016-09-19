module IcelabCrm
  def self.api_host
    ENV['ICELAB_CRM_API_HOST'] || "localhost:3000"
  end

  def self.api_protocol
    ENV['ICELAB_CRM_API_PROTOCOL'] || "http"
  end

  def self.api_host_url
    "#{api_protocol}://#{api_host}"
  end
end
