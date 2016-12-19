module GitSpec
  ##
  # A representation of a file in GitSpec.
  #
  class File
    extend Forwardable
    def_delegator :@path, :extname

    attr_reader :configuration

    def initialize(filename, configuration = GitSpec.configuration)
      @path = Pathname.new(filename.strip)
      @configuration = configuration
    end

    ##
    # Returns the path as a string
    #
    # @return [String]
    #
    def path
      @path.to_s
    end

    ##
    # Set the path and reset the cached spec_path
    #
    # @param [String|Pathname] v The value to set
    #
    def path=(v)
      @path = Pathname.new(v)
      @spec_path = nil
    end

    ##
    # Using the test_dir and test_file_suffix, build the expected spec path.
    #
    # @return [String]
    #
    def spec_path
      @spec_path ||= begin
        dir, base = @path.split

        # If the file is already a spec, exit early
        return @path.to_s if dir.to_s.start_with?(configuration.test_dir)

        # Remove the app root from the spec path
        dir = dir.sub(configuration.src_root, '')
        # Add the test directory to the front
        dir = Pathname.new(configuration.test_dir) + dir
        # Rename the file to include the test file suffix
        base = base.sub(extname, configuration.test_file_suffix + extname)

        (dir + base).to_s
      end
    end

    ##
    # Is the file excluded from GitSpec processing?
    #
    # @see GitSpec::Configuration.allowed_file_types
    # @see GitSpec::Configuration.excluded_file_patterns
    #
    # @return [Boolean] if the file is not excluded
    # @return [Boolean, Symbol] true, reason
    #
    def excluded?
      return true, :forbidden_file_type unless allowed_file_type?
      is_blacklisted = excluded_by_blacklisted_file_patterns?(path)

      if is_blacklisted
        return is_blacklisted, :excluded_file_pattern
      else
        return is_blacklisted
      end
    end

    ##
    # Is this file allowed?
    #
    # @see GitSpec::Configuration.allowed_file_types
    #
    # @return [Boolean]
    #
    def allowed_file_type?
      configuration.allowed_file_types.include?(extname)
    end

    private

    ##
    # Does the filename match any of the excluded_file_patterns?
    #
    # @param [String | Pathname] filename
    #
    # @return [Boolean]
    #
    def excluded_by_blacklisted_file_patterns?(filename)
      should_exclude = false

      configuration.excluded_file_patterns.each do |pattern|
        match = filename.to_s =~ pattern

        unless match.nil?
          should_exclude = true
          break
        end
      end
      should_exclude
    end

  end
end
