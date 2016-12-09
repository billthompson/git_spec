module GitSpec
  class Configuration
    attr_accessor :src_root, :log_level


    def initialize
      @src_root = 'lib/'
      @log_level = ::Logger::INFO
    end
  end
end
