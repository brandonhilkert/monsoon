begin
  require "aws/s3"
rescue LoadError
  raise "You don't have the 'aws' gem installed."
end

module Monsoon
  class Store

    def initialize(filename, bucket, key, secret)
      @filename, @bucket, @key, @secret  = filename, bucket, key, secret
    end

    # Runs the Monsoon Store save process.
    #
    # Examples
    #
    #   Monsoon::Store("backup.tar.gz", "backups_bucket", "super_secret_key", "super_secret_secret").save
    #   # => #<AWS::S3::S3Object>
    #
    # Returns an instance of the AWS::S3::S3Object class
    def save
      connect
      AWS::S3::S3Object.store(@filename, read_file_contents, @bucket)
    end

    # Parses the contents of the compressed backup.
    #
    # Examples
    #
    #   Monsoon::Store("backup.tar.gz", "backups_bucket", "super_secret_key", "super_secret_secret").read_file_contents
    #   # => #<AWS::S3::S3Object>
    #
    # Returns contents of the binary file.
    def read_file_contents
      file = File.open(@filename, "rb")
      file.read
    end

    # Connects to AWS.
    #
    # Examples
    #
    #   Monsoon::Store("backup.tar.gz", "backups_bucket", "super_secret_key", "super_secret_secret").connect
    #   # => #<AWS::S3::Connection>
    #
    # Returns an instance of the AWS::S3::Connection class.
    def connect
      AWS::S3::Base.establish_connection!(
        :access_key_id     => @key, 
        :secret_access_key => @secret
      )
    end
  end
end