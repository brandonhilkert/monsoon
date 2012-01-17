module Monsoon

  class << self
    attr_accessor :bucket, :key, :secret, :backup_directory, :mongo_uri

    # config/initializers/monsoon.rb (for instance)
    #
    # Monsoon.configure do |config|
    #   config.bucket = 'backups'
    #   config.key = 'consumer_key'
    #   config.secret = 'consumer_secret'
    #   config.backup_directory = 'data'
    #   config.mongo_uri = 'mongodb://testuser:pass1@test.mongohq.com:10036/app_development'
    # end
    #
    # elsewhere
    #
    # client = Monsoon::Client.new
    def configure
      yield self
      true
    end
  end

  autoload :Backup,     "monsoon/backup"
  autoload :Client,     "monsoon/client"
  autoload :Compress,   "monsoon/compress"
  autoload :Store,      "monsoon/store"
  autoload :Version,    "monsoon/version"
end
