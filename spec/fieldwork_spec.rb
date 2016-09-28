require 'spec_helper'

describe Fieldwork do
  describe "configuration" do
    it "can have a global configuration" do
      Fieldwork.configure do |config|
        config.project_id = "foo_id"
      end

      expect(Fieldwork.configuration).to be_an_instance_of Fieldwork::Configuration
    end

    it "can be globally configured with a project id" do
      Fieldwork.configure { |config| config.project_id = "foo_id" }
      expect(Fieldwork.configuration.project_id).to eq "foo_id"
    end

    it "can be globally configured with a project public key" do
      Fieldwork.configure { |config| config.project_public_key = "foo_key" }
      expect(Fieldwork.configuration.project_public_key).to eq "foo_key"
    end
  end
end
