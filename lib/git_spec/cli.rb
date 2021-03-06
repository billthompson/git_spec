require 'thor'
require 'pty'
require 'pry'

module GitSpec
  class CLI < Thor
    # This is not threadsafe but we can revisit this if we need to support this in the future
    RUNNING_PIDS = []

    desc "spec [COMMAND]", "Execute COMMAND with files arg"
    method_option :command, aliases: ['-c']
    method_option :src_root
    method_option :log_level, type: :numeric, aliases: ['-l']
    method_option :dry_run, type: :boolean, default: false, aliases: ['-d']
    def spec
      GitSpec.configure do |config|
        config.spec_command = options.command if options.command
        config.src_root = options.src_root if options.src_root
        config.log_level = options.log_level if options.log_level
      end

      files, missing_files = GitSpec.changed_files
      missing_files_banner(missing_files) if missing_files.any?
      filtered_to_banner(files) if files.any?

      if options.dry_run
        say("Dry run enabled. Would have sent the following files to the spec runner:", :yellow)
        say(files.join(' '), :yellow)
        return
      end

      ##
      # We want to be able to stream the STDOUT to the terminal while the spec runner is working.
      # IO.popen() won't work for this because we won't get the STDOUT until the process is complete.
      #
      # This SO answer is a great read http://stackoverflow.com/a/1162850
      #
      spec_command_with_args = "#{GitSpec.configuration.spec_command} #{files.join(' ')}"
      PTY.spawn(spec_command_with_args) do |stdout, stdin, pid|
        RUNNING_PIDS << pid

        begin
          stdout.each { |line| print line }
        rescue Errno::EIO
        end
      end
    rescue PTY::ChildExited
    end

    desc "changed_files", "The list of spec files the spec runner will be executed with."
    method_option :src_root
    method_option :log_level, type: :numeric, aliases: ['-l']
    def changed_files
      GitSpec.configure do |config|
        config.src_root = options.src_root if options.src_root
        config.log_level = options.log_level if options.log_level
      end

      files = GitSpec.changed_files
      say(files.join(' '))
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
