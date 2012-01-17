# encoding: UTF-8
require 'uri'

module Monsoon
  class Backup

    def initialize(uri)
      @uri = uri
    end

    def run
      Kernel.system "#{mongo_backup}" 
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

    def database
      config["database"]
    end

    def mongo_backup
      command = ""
      command = "mongodump -h #{config['host']}:#{config['port']} -d #{config['database']} -o tmp "
      command += "--username #{config['username']} --password #{config['password']}" unless config["username"].nil? and config["password"].nil?
      command
    end
  end
end