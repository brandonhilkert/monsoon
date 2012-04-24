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
      AWS::S3::S3Object.store(@filename, file_handle, @bucket)
    end

    # Creates File handler for backup file.
    #
    # Examples
    #
    #   Monsoon::Store("backup.tar.gz", "backups_bucket", "super_secret_key", "super_secret_secret").file_handle
    #   # => #<AWS::S3::S3Object>
    #
    # Returns File object of backup file.
    def file_handle
      File.open(@filename, "rb")
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