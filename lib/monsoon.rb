module Monsoon

  class << self
    attr_accessor :bucket, :key, :secret, :mongo_uri

    # config/initializers/monsoon.rb (for instance)
    #
    # Monsoon.configure do |config|
    #   config.bucket = 'backups'
    #   config.key = 'consumer_key'
    #   config.secret = 'consumer_secret'
    #   config.mongo_uri = 'mongodb://testuser:pass1@test.mongohq.com:10036/app_development'
    # end
    #
    def configure
      yield self
      true
    end

    # Run the Monsoon process to backup, save, and clean the work.
    #
    # Examples
    #
    #   Monsoon.perform
    #   # => True
    #
    # Returns True
    def perform
      Monsoon::Client.new.run
    end
  end

  autoload :Backup,     "monsoon/backup"
  autoload :Client,     "monsoon/client"
  autoload :Compress,   "monsoon/compress"
  autoload :Store,      "monsoon/store"
  autoload :Version,    "monsoon/version"
end
