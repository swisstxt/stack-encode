module StackEncode
  require 'yaml'
  
  class Profile

    def initialize(profile_path)
      @profile_path = profile_path
    end

    def settings(type = :all)
      @settings ||= YAML.load_file @profile_path
    end

  end
end
