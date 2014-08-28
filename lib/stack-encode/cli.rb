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
      desc: "video format",
      aliases: '-v',
      default: 'mp4'
    option :audio_format,
      desc: "audio format",
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
    def encode(*files)
      FFMPEG.logger = Logger.new(options[:log_file])
      files.each do |source|
        unless File.file?(source)
          puts "#{source} is not a valid file"
          next
        end
        movie = FFMPEG::Movie.new(source)
        dest_format = movie.video_stream ? options[:video_format] : options[:audio_format]
        dest_dir = options[:destination] || File.dirname(source)
        filename = File.basename(source, File.extname(source)) + ".#{dest_format}"
        banner = "Encoding #{File.basename(source)} to #{dest_format.upcase} ==> #{filename}"
        puts banner unless options[:progress]
        transcoded_movie = movie.transcode(
          File.expand_path(
            "#{dest_dir}/" + filename
          )
        ) do |progress|
          if options[:progress]
            print_progress(progress * 100, banner)
          end
        end
        puts if options[:progress]
        transcoded_movie
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
