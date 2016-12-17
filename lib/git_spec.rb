require 'logger'

require 'git_spec/version'
require 'git_spec/configuration'
require 'git_spec/logger'
require 'git_spec/status'
require 'git_spec/file'

module GitSpec
  class << self
    attr_reader :configuration, :logger
  end

  def self.configuration
    @configuration || configure
  end

  def self.configure
    @configuration ||= Configuration.new

    yield(configuration) if block_given?

    @logger = GitSpec::Logger.new(STDOUT)
    logger.level = configuration.log_level

    @configuration
  end


  def self.changed_files
    logger.debug "Gathering changed files..."
    all_spec_paths = GitSpec::Status.changed_files.map(&:spec_path)
    segment_paths(all_spec_paths)
  end

  private

  def self.segment_paths(paths)
    exists = paths.select{|f| ::File.exists?(f)}
    dont_exist = paths - exists

    return exists, dont_exist
  end


end
