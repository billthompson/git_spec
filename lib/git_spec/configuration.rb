require 'yaml'
require 'erb'

module GitSpec
  class Configuration
    attr_accessor :excluded_file_patterns, :log_level, :src_root, :spec_command

    def initialize
      load_config!
    end

    private

    ##
    # Load the file based config file and merge the safe options into the configuration.
    #
    def load_config!
      options = load_file
      options.each do |k, v|
        config_key_setter = "#{k}=".to_sym
        self.public_send(config_key_setter, v) if respond_to?(config_key_setter)
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
      YAML.load(ERB.new(::File.read(config_path)).result) if ::File.exists?(config_path)
    rescue => e
      puts "Error parsing GitSpec configuration file at #{config_path}. Please check for syntax errors and try again."
    end
  end
end
