module Monsoon
  class Compress

    def initialize(backup)
      @backup = backup
    end

    def run
      Kernel.system "#{compress_command}" 
    end

    def compress_command
      "tar -czf  #{filename} #{@backup.backup_directory}"
    end

    def filename
      "#{@backup.database}.#{Time.now.utc.to_i.to_s}.tar.gz"
    end

  end
end