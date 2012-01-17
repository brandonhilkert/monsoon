# encoding: UTF-8
require 'uri'

module Monsoon
  class Backup

    def initialize(uri)
      @uri = uri
    end

    def run
      Kernel.system "#{mongodump}" 
    end       

    def config
      return {} unless @uri

      uri = URI.parse(@uri)
      raise "must be a mongo DB" unless uri.scheme == 'mongodb'
      {
        "host"     => uri.host,
        "port"     => uri.port,
        "database" => uri.path.gsub(/^\//, ''),
        "username" => uri.user,
        "password" => uri.password
      }
    end    

    def mongo_backup
      "mongodump -h #{config['host']} -p #{config['port']} -u #{config['username']} -p #{config['password']} -d #{config['database']}"
    end
  end
end