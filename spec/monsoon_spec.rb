require 'spec_helper'

describe Monsoon do
  before(:each) do
    Monsoon.bucket = nil
    Monsoon.key = nil
    Monsoon.secret = nil
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
      config.mongo_uri          = "mongodb://testuser:pass1@test.mongohq.com:10036/app_development"
    end

    Monsoon.bucket.should == "backups"
    Monsoon.key.should == "key"
    Monsoon.secret.should == "secret"
    Monsoon.mongo_uri.should == "mongodb://testuser:pass1@test.mongohq.com:10036/app_development"
  end

  describe ".perform" do
    before(:each) do
      Monsoon::Client.any_instance.stub(:run).and_return(true)
    end

    it "should excute the run method on a client instance" do
      Monsoon::Client.any_instance.should_receive(:run)
      Monsoon.perform
    end
  end
end