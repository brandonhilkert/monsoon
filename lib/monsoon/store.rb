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

    def save
      connect
      AWS::S3::S3Object.store(@filename, read_file_contents, @bucket)
    end

    def read_file_contents
      file = File.open(@filename, "rb")
      file.read
    end

    def connect
      AWS::S3::Base.establish_connection!(
        :access_key_id     => @key, 
        :secret_access_key => @secret
      )
    end
  end
end