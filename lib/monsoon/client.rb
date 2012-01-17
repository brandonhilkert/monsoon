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
      b = backup.run
      c = compress(b).run
      s = store(c).run
    end

    def backup
      Backup.new(@mongo_uri, @backup_directory)
    end

    def compress(backup)
      Compress.new(backup)
    end
      
    def store(compress)
      Store.new(compress, @bucket, @key, @secret)
    end

  end
end