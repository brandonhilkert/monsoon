require 'uri'

module Monsoon
  class Backup

    def initialize(uri)
      @uri = uri
    end

    # Run the Monsoon Backup process.
    #
    # Examples
    #
    #   Monsoon::Backup("mongodb://@test.mongohq.com:10036/app_development").run
    #   # => #<Monsoon::Backup>
    #
    # Returns an instance of the Monsoon::Backup class
    def run
      Kernel.system "#{mongo_dump_command}"
      self
    end       

    # Creates the config hash for the connection string
    #
    # Examples
    #
    #   Monsoon::Backup("mongodb://test.mongohq.com:10036/app_development").config
    #   # => {"host" => "test.mongohq.com", 
    #         "post" => 10036, 
    #         "database" => "app_development",
    #         "username" => "testuser",
    #         "password" => "pass1"}
    #
    # Returns an instance of the Monsoon::Backup class
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

    # Helper method for database name.
    #
    # Examples
    #
    #   Monsoon::Backup("mongodb://test.mongohq.com:10036/app_development").database
    #   # => "app_development"
    #
    # Returns a String of the database name.
    def database
      config["database"]
    end

    # Helper to form the mongodump command.
    #
    # Examples
    #
    #   Monsoon::Backup("mongodb://test.mongohq.com:10036/app_development").mongo_dump_command
    #   # => "mongodump -h test.mongohq.com:10036 -d app_development"
    #
    # Returns the command as a String.
    def mongo_dump_command
      cmd = ""
      cmd = "mongodump -h #{config['host']}:#{config['port']} -d #{config['database']} "
      cmd += "--username #{config['username']} --password #{config['password']}" unless config["username"].nil? and config["password"].nil?
      cmd
    end
  end
end