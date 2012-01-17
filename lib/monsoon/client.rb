module Monsoon
  class Client

    def initialize(bucket = Monsoon.bucket, key = Monsoon.key, secret = Monsoon.secret, backup_directory = Monsoon.backup_directory, mongo_uri = Monsoon.mongo_uri)
      @bucket           = bucket
      @key              = key
      @secret           = secret
      @backup_directory = backup_directory
      @mongo_uri        = mongo_uri
    end

    # Run the Monsoon process to backup, save, and clean the work.
    #
    # Examples
    #
    #   Monsoon::Client.new.run
    #   # => True
    #
    # Returns True
    def run
      # Backup the MongoDB database to filesystem
      b = backup.run
      
      # Compress the contents of the backup
      c = compress(b).run
      
      # Sent to AWS
      store(c.filename).save

      # Remove the compressed file from the filesystem
      c.clean

      true
    end

    # Creates an instance of the Monsoon::Backup class
    #
    # Examples
    #
    #   Monsoon::Client.new.backup
    #   # => #<Monsoon::Backup>
    #
    # Returns an instance of the Monsoon::Client object
    def backup
      Backup.new(@mongo_uri, @backup_directory)
    end

    # Creates an instnace of the Monsoon::Compress class
    #
    # backup  - The Monsoon::Backup instance the preceeded.
    #
    # Examples
    #
    #   Monsoon::Client.new.compress(#<Monsoon::Backup>)
    #   # => #<Monsoon::Compress>
    #
    # Returns an instance of the Monsoon::Compress object
    def compress(backup)
      Compress.new(backup)
    end
      
    # Creates an instance of the Monsoon::Store class
    #
    # filename  - The String filename of the compressed backup to push to S3.
    #
    # Examples
    #
    #   Monsoon::Client.new.store("test.tar.gz")
    #   # => #<Monsoon::Store>
    #
    # Returns an instance of the Monsoon::Store object
    def store(filename)
      Store.new(filename, @bucket, @key, @secret)
    end

  end
end