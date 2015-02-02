module StackEncode
  require 'find'
  require 'thor'
  require 'streamio-ffmpeg'

  class Cli < Thor
    include Thor::Actions

    def self.exit_on_failure?
      true
    end

    # catch control-c and exit
    trap("SIGINT") {
      puts " bye"
      exit!
    }

    package_name "stack-encode"
    map %w(-v --version) => :version

    desc "version", "Outputs the version number"
    def version
      say "stack-encode v#{StackEncode::VERSION}"
    end

    desc "encode FILES", "Encodes a number video or audio files"
    option :destination,
      desc: "destination directory",
      aliases: '-d'
    option :video_format,
      desc: "destination video format",
      aliases: '-v',
      default: 'mp4'
    option :audio_format,
      desc: "destination audio format",
      aliases: '-a',
      default: 'mp3'
    option :log_file,
      desc: "log file path",
      aliases: '-l',
      default: '/dev/null'
    option :progress,
      desc: "show encoding progress",
      type: :boolean,
      default: true
    option :profile,
      desc: "path to profile file (YAML)",
      aliases: '-p',
      default: ENV['STACKENCODE_PROFILE'] || nil
    option :ffmpeg_options,
      desc: "custom ffmpeg options string",
      aliases: '-o',
      default: ENV['FFMPEG_OPTIONS'] || ""
    def encode(*files)
      FFMPEG.logger = Logger.new(options[:log_file])
      profile = Profile.new(
        profile_path: options[:profile],
        custom_options: options[:ffmpeg_options]
      )
      files.each do |source|
        unless File.file?(source)
          puts "#{source} is not a valid file"
          next
        end
        file = FFMPEG::Movie.new(source)
        dest_format = file.video_stream ? options[:video_format] : options[:audio_format]
        dest_dir = options[:destination] || File.dirname(source)
        filename = File.basename(source, File.extname(source)) + ".#{dest_format}"
        banner = "Encoding #{File.basename(source)} to #{dest_format.upcase} ==> #{filename}"
        say banner unless options[:progress]
        transcoded_file = file.transcode(
          File.expand_path(File.join(dest_dir, filename)),
          file.video_stream ? profile.video_options : profile.audio_options,
          profile.transcoder_options
        ) do |progress|
          if options[:progress]
            print_progress(progress * 100, banner)
          end
        end
        say if options[:progress]
        transcoded_file
      end
    end

    desc "info FILES", "Print information for a number video or audio files"
    def info(*files)
      files.each do |source|
        unless File.file?(source)
          puts "#{source} is not a valid file"
          next
        end
        file = FFMPEG::Movie.new(source)
        if file.valid?
          say source, :green
          table = [
            ["file type", file.video_stream ? "video" : "audio"],
            ["duration", file.duration.to_s + " sec"],
            ["bitrate", file.bitrate.to_s + " kb/s"],
            ["size", file.size.to_s + " bytes"]
          ]
          table += if file.video_stream
            [
              ["video_codec", file.video_codec],
              ["colorspace", file.colorspace],
              ["resolution", file.resolution],
              ["frame_rate", file.frame_rate.to_s + " fps"],
              ["audio_codec", file.audio_codec],
              ["audio_sample_rate", file.audio_sample_rate.to_s],
              ["audio_channels", file.audio_channels.to_s]
            ]
          else
            [
              ["audio_codec", file.audio_codec],
              ["audio_sample_rate", file.audio_sample_rate.to_s],
              ["audio_channels", file.audio_channels.to_s]
            ]
          end
          print_table table
          puts
        else
          puts "Invalid source file"
        end
      end
    end

    no_commands do
      # Helper function to print a progress bar in the console
      def print_progress(progress, banner)
        print "\r#{banner}:\t[" + ('#' * (progress.round / 3)) + (' ' * (100/3 - progress.round / 3)) + ']'
        printf (progress < 100 ? "  %02d\%" : " %3d\%"), progress
        $stdout.flush
      end
    end
  end
end
