module StackEncode
  require 'yaml'

  class Profile

    def initialize(options = {})
      @profile_path = options[:profile_path] ? options[:profile_path] : nil
      @custom_options = options[:custom_options] ? options[:custom_options] : nil
    end

    def settings
      @settings ||= if @profile_path
        begin
          YAML.load_file @profile_path
        rescue SystemCallError
          $stderr.puts "Can't find profile #{@profile_path}."
          exit 1
        rescue => e
          $stderr.puts "Error parsing profile (#{@profile_path}):"
          $stderr.puts e.message
          exit 1
        end
      else
        {}
      end
    end

    def video_options
      video_options = settings['video'] ? settings['video'] : {}
      merge_custom_options(video_options)
    end

    def audio_options
      audio_options = settings['audio'] ? settings['audio'] : {}
      merge_custom_options(audio_options)
    end

    def transcoder_options
      @settings['transcoder'] ? @settings['transcoder'] : {}
    end

    private

    def merge_custom_options(options)
      profile_options = options['custom'] ? options['custom'] : ''
      options['custom'] = [profile_options, @custom_options].join(' ').strip || ''
      options
    end

  end
end
