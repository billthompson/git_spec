require 'yaml'

module GitSpec
  class Configuration
    attr_accessor :src_root, :log_level, :spec_command

    ##
    # List of configuration options safe for the outside world to set freely
    #
    OVERRIDABLE_OPTIONS = [:src_root, :log_level, :spec_command]

    def initialize
      @src_root = 'lib/'
      @log_level = ::Logger::INFO
      @spec_command = 'bundle exec rspec'

      merge_file_overrides
    end

    private

    ##
    # Load the file based config file and merge the safe options into the configuration.
    #
    def merge_file_overrides
      options = safe_options(load_file)
      options.each do |k, v|
        self.public_send("#{k}=".to_sym, v)
      end
    end

    ##
    # Load the git_spec.yml configuration file
    #
    # @return [Hash]
    # @return [NilClass] if the file doesn't exist or there was a parser error
    #
    def load_file
      config_path = ::File.join(Dir.getwd, 'git_spec.yml')
      YAML.load_file(config_path) if ::File.exists?(config_path)
    rescue => e
      puts "Error parsing GitSpec configuration file at #{config_path}. Please check for syntax errors and try again."
    end

    ##
    # Select the options users are allowed to override from the raw, unsafe config
    #
    # @param [Hash] unsafe_config Hash containing safe/unsafe key/value pairs
    #
    # @return [Hash]
    #
    def safe_options(unsafe_config)
      return {} unless unsafe_config.respond_to?(:select)
      unsafe_config.select{|c| OVERRIDABLE_OPTIONS.include?(c.to_sym)}
    end
  end
end
