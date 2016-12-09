require 'thor'

module GitSpec
  class CLI < Thor
    desc "spec [COMMAND]", "Execute COMMAND with files arg"
    method_option :command, default: 'bundle exec rspec', aliases: ['-c']
    method_option :src_root, default: 'lib/'
    method_option :log_level, type: :numeric, default: Logger::INFO, aliases: ['-l']
    method_option :dry_run, type: :boolean, default: false, aliases: ['-d']
    method_option :project_root, default: Dir.getwd
    def spec
      GitSpec.configure do |config|
        config.git_root = options.project_root
        config.src_root = options.src_root
        config.log_level = options.log_level
      end

      files, missing_files = GitSpec.changed_files
      missing_files_banner(missing_files) if missing_files.any?
      filtered_to_banner(files) if files.any?

      if options.dry_run
        say("Dry run enabled. Would have sent the following files to the spec runner:", :yellow)
        say(files.join(' '), :yellow)
      else
        system "#{options.command} #{files.join(' ')}"
      end

    end

    private

    def missing_files_banner(missing_files)
      say("Expected specs at the following locations but they could not be found:", :red)

      missing_files.each do |filename|
        say("  * #{filename}", :red)
      end
      puts
      puts
    end

    def filtered_to_banner(files)
      say("Executing the spec runner for:", :green)

      files.each do |filename|
        say("  * #{filename}", :green)
      end
      puts
      puts
    end


  end
end
