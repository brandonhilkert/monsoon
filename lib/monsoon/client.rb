module Monsoon
  class Client

    def initialize(bucket = Monsoon.bucket, key = Monsoon.key, secret = Monsoon.secret, backup_directory = Monsoon.backup_directory, mongo_uri = Monsoon.mongo_uri)
      @bucket           = bucket
      @key              = key
      @secret           = secret
      @backup_directory = backup_directory
      @mongo_uri        = mongo_uri
    end

    def run
      # Backup the MongoDB database to filesystem
      b = backup.run
      
      # Compress the contents of the backup
      c = compress(b).run
      
      # Sent to AWS
      store(c.filename).save

      # Remove the compressed file from the filesystem
      c.clean
    end

    def backup
      Backup.new(@mongo_uri, @backup_directory)
    end

    def compress(backup)
      Compress.new(backup)
    end
      
    def store(filename)
      Store.new(filename, @bucket, @key, @secret)
    end

  end
end