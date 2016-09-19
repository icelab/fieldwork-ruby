require "spec_helper"

describe IcelabCrm::Client do
  describe "configuration" do
    it "can be initialized with a configuration" do
      configuration = IcelabCrm::Configuration.new
      client = described_class.new(configuration: configuration)

      expect(client.configuration).to eq configuration
    end

    it "raises an error if initialized without a configuration" do
      expect { described_class.new }.to raise_error(
        IcelabCrm::ConfigurationError, "No configuration provided to client instance"
      )
    end
  end

  describe "#track_event" do
    describe "preflight" do
      it "ensures that a configuration is available" do
        expect { described_class.new(configuration: nil).track_event("foo", {bar: "baz"}) }.to raise_error(
          IcelabCrm::ConfigurationError, "client must be configured before use"
        )
      end

      it "ensures that a project id has been configured" do
        configuration = IcelabCrm::Configuration.new
        client = described_class.new(configuration: configuration)
        expect { client.track_event("foo", {bar: "baz"}) }.to raise_error(
          IcelabCrm::ConfigurationError, "Please configure a project_id before tracking events"
        )
      end

      it "ensures that a project public key has been configured" do
        configuration = IcelabCrm::Configuration.new(project_id: "foo_id")
        client = described_class.new(configuration: configuration)
        expect { client.track_event("foo", {bar: "baz"}) }.to raise_error(
          IcelabCrm::ConfigurationError, "Please configure a project_public_key before tracking events"
        )
      end
    end
  end
end
