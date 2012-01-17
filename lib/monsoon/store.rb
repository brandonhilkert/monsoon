begin
  require "fog"
rescue LoadError
  raise "You don't have the 'fog' gem installed."
end

module Monsoon
  class Store
    def initialize(compress, bucket, key, secret)
      @compress, @bucket, @key, @secret  = compress, bucket, key, secret
    end

    def run
      fog.put_object(@bucket, @compress.filename, read_file_contents)
    end

    def read_file_contents
      file = File.open(@compress.filename, "rb")
      file.read
    end

    def fog
      Fog::Storage.new(
        :provider               => 'AWS', 
        :aws_access_key_id      => @key, 
        :aws_secret_access_key  => @secret
      )
    end
  end
end