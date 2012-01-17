require 'spec_helper'

module Monsoon

  describe Client do
    let(:bucket) { "bucket" }
    let(:key) { "key" }
    let(:secret) { "secret" }
    let(:backup_directory) { "tmp" }
    let(:mongo_uri) { "mongodb://testuser:pass1@test.mongohq.com:10036/app_development" }
    let(:client) { Monsoon::Client.new(bucket, key, secret, backup_directory, mongo_uri) }

    describe "initalization" do
      it "should set the @bucket instance variable" do
        client.instance_variable_get(:@bucket).should == bucket
      end

      it "should set the @key instance variable" do
        client.instance_variable_get(:@key).should == key
      end

      it "should set the @secret instance variable" do
        client.instance_variable_get(:@secret).should == secret
      end

      it "should set the @backup_directory instance variable" do
        client.instance_variable_get(:@backup_directory).should == backup_directory 
      end

      it "should set the @mongo_uri instance variable" do
        client.instance_variable_get(:@mongo_uri).should == mongo_uri
      end
    end

    describe "#run" do
      let(:backup) { Backup.new(mongo_uri, backup_directory) }
      let(:compress) { Compress.new(backup) }
      let(:store) { Store.new(compress, bucket, key, secret) }

      before(:each) do
        Backup.any_instance.stub(:run).and_return(backup)
        Compress.any_instance.stub(:run).and_return(compress)
        Store.any_instance.stub(:run).and_return(store)
      end

      it "should run the backup process" do
        Backup.any_instance.should_receive(:run)
        client.run
      end

      it "should run the compress process" do
        Compress.any_instance.should_receive(:run)
        client.run
      end

      it "should run the store process" do
        Store.any_instance.should_receive(:run)
        client.run
      end
    end

    describe "#backup" do
      it "should initalize a new Backup object" do
        Backup.should_receive(:new).with(mongo_uri, backup_directory)
        client.backup
      end
    end

    describe "#compress" do
      let(:backup) { Backup.new(mongo_uri, backup_directory) }

      it "should initalize a new Compress object" do
        Compress.should_receive(:new).with(backup)
        client.compress(backup)
      end
    end

    describe "#store" do
      let(:backup) { Backup.new(mongo_uri, backup_directory) }
      let(:compress) { Compress.new(backup) }

      it "should initalize a new Compress object" do
        Compress.should_receive(:new).with(compress, bucket, key, secret)
        client.store(compress)
      end
    end

  end

end