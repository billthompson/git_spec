module GitSpec
  class Status
    def initialize(logger = GitSpec.logger)
      @logger = logger
    end

    def changed_files
      changed_files = (filenames).each_with_object([]) do |filename, changed|
        file = File.new(filename)

        excluded, excluded_reason = file.excluded?
        if excluded
          @logger.debug "Excluding #{file.spec_path} with reason: #{excluded_reason}"
        else
          changed << file
          @logger.debug "Including #{file.spec_path}"
        end
      end

      changed_files.uniq{|f| f.spec_path}
    rescue => e
      # TODO: Log helpful info when this happens
      raise
    end

    def self.changed_files
      new.changed_files
    end

    private

    def filenames
      files = %x[git diff --name-only master..HEAD && git ls-files --exclude-standard --others && git diff --name-only && git diff --name-only --cached]
      files.split("\n")
    end

  end
end
