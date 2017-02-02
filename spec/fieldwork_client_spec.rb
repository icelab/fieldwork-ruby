require "spec_helper"

describe Fieldwork::Client do
  let(:api_request_headers) {
    {
      'Accept'=>'*/*',
      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'Content-Type'=>'application/json',
      'User-Agent'=>"Fieldwork/#{Fieldwork::VERSION} ruby"
    }
  }

  describe "configuration" do
    it "can be initialized with a configuration" do
      configuration = Fieldwork::Configuration.new
      client = described_class.new(configuration: configuration)

      expect(client.configuration).to eq configuration
    end

    it "raises an error if initialized without a configuration" do
      expect { described_class.new }.to raise_error(
        Fieldwork::ConfigurationError, "No configuration provided to client instance"
      )
    end
  end

  describe "#add_entity" do
    describe "preflight" do
      it "ensures that a configuration is available" do
        expect { described_class.new(configuration: nil).add_entity("foo", {id: 1, bar: "baz"}) }.to raise_error(
          Fieldwork::ConfigurationError, "client must be configured before use"
        )
      end

      it "ensures that a project id has been configured" do
        configuration = Fieldwork::Configuration.new
        client = described_class.new(configuration: configuration)
        expect { client.add_entity("foo", {id: 1, bar: "baz"}) }.to raise_error(
          Fieldwork::ConfigurationError, "Please configure a project_id before tracking events"
        )
      end

      it "ensures that a project public key has been configured" do
        configuration = Fieldwork::Configuration.new(project_id: "foo_id")
        client = described_class.new(configuration: configuration)
        expect { client.add_entity("foo", {id: 1, bar: "baz"}) }.to raise_error(
          Fieldwork::ConfigurationError, "Please configure a project_public_key before tracking events"
        )
      end
    end

    context "with valid credentials" do
      before do
        stub_request(:post, "http://api.dofieldwork.com/api/v1/projects/project-id/entities")
          .with(
            body: "{\"name\":\"user\",\"properties\":{\"id\":1,\"email\":\"user@example.com\"}}",
            headers: api_request_headers.merge('Authorization'=>'Basic cHJvamVjdC1wdWJsaWMta2V5Og==')
          ).to_return(status: 200, body: '{"status": "ok"}', headers: {})
      end

      it "sends an event and properties to the fieldwork api and returns status ok" do
        client = described_class.new(
          configuration: Fieldwork::Configuration.new(
            project_id: "project-id", project_public_key: "project-public-key"
          )
        )

        expect(
          client.add_entity("user", {id: 1, email: "user@example.com"})
        ).to eq(status: "ok")
      end
    end

    context "with invalid credentials" do
      before do
        stub_request(:post, "http://api.dofieldwork.com/api/v1/projects/project-id/entities")
          .with(
            body: "{\"name\":\"user\",\"properties\":{\"id\":1,\"email\":\"user@example.com\"}}",
            headers: api_request_headers.merge('Authorization'=>'Basic aW52YWxpZC1rZXk6')
          ).to_return(
            status: 422,
            body: "{\"status\":\"error\",\"message\":\"Incorrect project id or public key. Please double check your project's id and public key\"}",
            headers: {}
          )
      end

      it "sends an event and properties to the fieldwork api but raises an api error" do
        client = described_class.new(
          configuration: Fieldwork::Configuration.new(
            project_id: "project-id", project_public_key: "invalid-key"
          )
        )

        expect{
          client.add_entity("user", {id: 1, email: "user@example.com"})
        }.to raise_error Fieldwork::ApiError, "Incorrect project id or public key. Please double check your project's id and public key"
      end
    end

    context "with a missing endpoint" do
      before do
        stub_request(:post, "http://api.dofieldwork.com/api/v1/projects/project-id/entities")
          .with(
            body: "{\"name\":\"user\",\"properties\":{\"id\":1,\"email\":\"user@example.com\"}}",
            headers: api_request_headers.merge('Authorization'=>'Basic cHJvamVjdC1wdWJsaWMta2V5Og==')
          ).to_return(status: 404, body: '', headers: {})
      end

      it "sends an event and properties to the fieldwork api and but raises an api error" do
        client = described_class.new(
          configuration: Fieldwork::Configuration.new(
            project_id: "project-id", project_public_key: "project-public-key"
          )
        )

        expect{
          client.add_entity("user", {id: 1, email: "user@example.com"})
        }.to raise_error Fieldwork::ApiError, "404 endpoint not found: http://api.dofieldwork.com/api/v1/projects/project-id/entities"
      end
    end
  end

  describe "#track_event" do
    describe "preflight" do
      it "ensures that a configuration is available" do
        expect { described_class.new(configuration: nil).track_event("foo", {bar: "baz"}) }.to raise_error(
          Fieldwork::ConfigurationError, "client must be configured before use"
        )
      end

      it "ensures that a project id has been configured" do
        configuration = Fieldwork::Configuration.new
        client = described_class.new(configuration: configuration)
        expect { client.track_event("foo", {bar: "baz"}) }.to raise_error(
          Fieldwork::ConfigurationError, "Please configure a project_id before tracking events"
        )
      end

      it "ensures that a project public key has been configured" do
        configuration = Fieldwork::Configuration.new(project_id: "foo_id")
        client = described_class.new(configuration: configuration)
        expect { client.track_event("foo", {bar: "baz"}) }.to raise_error(
          Fieldwork::ConfigurationError, "Please configure a project_public_key before tracking events"
        )
      end
    end

    context "with valid credentials" do
      before do
        stub_request(:post, "http://api.dofieldwork.com/api/v1/projects/project-id/events")
          .with(
            body: "{\"name\":\"user_created\",\"properties\":{\"email\":\"user@example.com\"}}",
            headers: api_request_headers.merge('Authorization'=>'Basic cHJvamVjdC1wdWJsaWMta2V5Og==')
          ).to_return(status: 200, body: '{"status": "ok"}', headers: {})
      end

      it "sends an event and properties to the fieldwork api and returns status ok" do
        client = described_class.new(
          configuration: Fieldwork::Configuration.new(
            project_id: "project-id", project_public_key: "project-public-key"
          )
        )

        expect(
          client.track_event("user_created", {email: "user@example.com"})
        ).to eq(status: "ok")
      end
    end

    context "with invalid credentials" do
      before do
        stub_request(:post, "http://api.dofieldwork.com/api/v1/projects/project-id/events")
          .with(
            body: "{\"name\":\"user_created\",\"properties\":{\"email\":\"user@example.com\"}}",
            headers: api_request_headers.merge('Authorization'=>'Basic aW52YWxpZC1rZXk6')
          ).to_return(
            status: 422,
            body: "{\"status\":\"error\",\"message\":\"Incorrect project id or public key. Please double check your project's id and public key\"}",
            headers: {}
          )
      end

      it "sends an event and properties to the fieldwork api but raises an api error" do
        client = described_class.new(
          configuration: Fieldwork::Configuration.new(
            project_id: "project-id", project_public_key: "invalid-key"
          )
        )

        expect{
          client.track_event("user_created", {email: "user@example.com"})
        }.to raise_error Fieldwork::ApiError, "Incorrect project id or public key. Please double check your project's id and public key"
      end
    end
  end
end
