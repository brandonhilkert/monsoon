require 'fileutils'

module Monsoon
  class Compress

    def initialize(backup)
      @backup = backup
    end

    # Run the Monsoon Compress process.
    #
    # Examples
    #
    #   Monsoon::Compress(#<Monsoon::Backup>).run
    #   # => #<Monsoon::Compress>
    #
    # Returns an instance of the Monsoon::Compress class
    def run
      Kernel.system "#{compress_command}"
      self
    end

    # Helper to form the tar compress command.
    #
    # Examples
    #
    #   Monsoon::Compress(#<Monsoon::Backup>).compress_command
    #   # => "tar -czf app_development_1234.tar.gz dump/app_development"
    #
    # Returns the command as a String.
    def compress_command
      "tar -czf #{filename} #{@backup.database}"
    end

    # Helper to form the tar compress command.
    #
    # Examples
    #
    #   Monsoon::Compress(#<Monsoon::Backup>).filename
    #   # => "app_development_1234.tar.gz"
    #
    # Returns the filename as a String.
    def filename
      @filename ||= "#{@backup.database}_#{Time.now.strftime('%Y%m%d_%H%M%S')}.tar.gz"
    end

    # Helper to delete the backup file once finished.
    #
    # Examples
    #
    #   Monsoon::Compress(#<Monsoon::Backup>).clean
    #   # => "app_development_1234.tar.gz"
    #
    # Returns results of the command.
    def clean
      FileUtils.rm filename, force: true
    end

  end
end