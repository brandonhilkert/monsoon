require 'spec_helper'

module Monsoon

  describe Store do
    let(:store) { Store.new("app_development.tar.gz", "backups", "key", "secret") }

    describe "initalization" do
      it "should set the @filename instance variable" do
        store.instance_variable_get(:@filename).should == "app_development.tar.gz"
      end

      it "should set the @key instance variable" do
        store.instance_variable_get(:@key).should == "key"
      end

      it "should set the @secret instance variable" do
        store.instance_variable_get(:@secret).should == "secret"
      end

      it "should set the @bucket instance variable" do
        store.instance_variable_get(:@bucket).should == "backups"
      end

    end

    describe "#save" do
      before(:each) do
        AWS::S3::S3Object.stub(:store).and_return(AWS::S3::S3Object)
        store.stub(:file_handle).and_return("test")
      end

      it "should connect to AWS" do
        store.should_receive(:connect)
        store.save
      end

      it "should execute store method on fog S3Object" do
        AWS::S3::S3Object.should_receive(:store).with("app_development.tar.gz", "test", "backups")
        store.save
      end

      it "should call the read_file_contents method" do
        store.should_receive(:file_handle)
        store.save
      end
    end

    describe "#file_handle" do
      before(:each) do
        File.stub(:open).with("app_development.tar.gz", "rb").and_return(File)
      end

      it "should open the File" do
        File.should_receive(:open).with("app_development.tar.gz", "rb")
        store.file_handle
      end
    end

    describe "#connect" do
      subject{ store.connection }

      it "should connect to AWS" do
        AWS::S3::Base.should_receive(:establish_connection!).with(:access_key_id => "key", :secret_access_key => "secret")
        store.connect
      end
    end

  end

end