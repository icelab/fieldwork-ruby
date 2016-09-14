require 'spec_helper'

describe IcelabCrm do
  describe "configuration" do
    it "can have a global configuration" do
      IcelabCrm.configure do |config|
        config.project_id = "foo_id"
      end

      expect(IcelabCrm.configuration).to be_an_instance_of IcelabCrm::Configuration
    end

    it "can be globally configured with a project id" do
      IcelabCrm.configure { |config| config.project_id = "foo_id" }
      expect(IcelabCrm.configuration.project_id).to eq "foo_id"
    end

    it "can be globally configured with a project public key" do
      IcelabCrm.configure { |config| config.project_public_key = "foo_key" }
      expect(IcelabCrm.configuration.project_public_key).to eq "foo_key"
    end
  end
end
