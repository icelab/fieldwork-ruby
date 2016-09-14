module IcelabCrm
  class Configuration
    attr_accessor :project_id
    attr_accessor :project_public_key

    def initialize(args={})
      @project_id = args.fetch(:project_id, nil)
      @project_public_key = args.fetch(:project_public_key, nil)
    end
  end
end
