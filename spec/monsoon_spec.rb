require 'spec_helper'

describe Monsoon do
  before(:each) do
    Monsoon.bucket = nil
    Monsoon.key = nil
    Monsoon.secret = nil
    Monsoon.backup_directory = nil
    Monsoon.mongo_uri = nil
  end

  it "should be able to set AWS properties" do
    Monsoon.bucket = "backups"
    Monsoon.key = "key"
    Monsoon.secret = "secret"

    Monsoon.bucket.should == "backups"
    Monsoon.key.should == "key"
    Monsoon.secret.should == "secret"
  end

  it "should be able to set options through configure block" do
    Monsoon.configure do |config|
      config.bucket             = "backups"
      config.key                = "key"
      config.secret             = "secret"
      config.backup_directory   = "tmp/data"
      config.mongo_uri          = "mongodb://testuser:pass1@test.mongohq.com:10036/app_development"
    end

    Monsoon.bucket.should == "backups"
    Monsoon.key.should == "key"
    Monsoon.secret.should == "secret"
    Monsoon.backup_directory.should == "tmp/data"
    Monsoon.mongo_uri.should == "mongodb://testuser:pass1@test.mongohq.com:10036/app_development"
  end
end