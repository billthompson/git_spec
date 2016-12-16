module GitSpec
  class File
    attr_reader :configuration, :path

    def initialize(filename, configuration = GitSpec.configuration)
      @path = filename.strip
      @configuration = configuration
    end

    def spec_path
      # TODO: Get test dir from config
      # TODO: Get spec naming convention from config
      @spec_path ||= begin
        filename = path
        filename = "spec/" << filename
        filename.gsub!(".rb", "_spec.rb")

        filename.gsub!(configuration.src_root, "")

        filename
      end
    rescue => e
      # TODO: Log helpful info when this happens
      raise
    end

    def excluded?
      return true, 'Invalid file type' unless is_ruby?
      filtered = should_filter?(path)

      if filtered
        return filtered, 'Excluded by file pattern match'
      else
        return filtered
      end
    end

    # TODO: Make this a whitelisted file extension configuration
    def is_ruby?
      ::File.extname(path) == '.rb'
    end

    def should_filter?(filename)
      should_exclude = false

      configuration.excluded_file_patterns.each do |pattern|
        match = filename =~ pattern

        unless match.nil?
          should_exclude = true
          break
        end
      end
      should_exclude
    end

  end
end
