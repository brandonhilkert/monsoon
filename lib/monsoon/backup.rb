require 'uri'

module Monsoon
  class Backup

    attr_reader :backup_directory

    def initialize(uri, backup_directory = "tmp")
      @uri = uri
      @backup_directory = backup_directory
    end

    def run
      Kernel.system "#{mongo_dump_command}"
      self
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

    def mongo_dump_command
      cmd = ""
      cmd = "mongodump -h #{config['host']}:#{config['port']} -d #{config['database']} -o tmp "
      cmd += "--username #{config['username']} --password #{config['password']}" unless config["username"].nil? and config["password"].nil?
      cmd
    end
  end
end