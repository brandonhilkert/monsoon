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

    describe "#run" do
      before(:each) do
        store.stub(:fog).and_return(Fog::Storage::AWS::Real)
        Fog::Storage::AWS::Real.stub(:put_object).and_return(true)
        store.stub(:read_file_contents).and_return("test")
      end

      it "should execute put_objejct method on fog object" do
        Fog::Storage::AWS::Real.should_receive(:put_object).with("backups", "app_development.tar.gz", "test")
        store.run
      end

      it "should call the read_file_contents method" do
        store.should_receive(:read_file_contents)
        store.run
      end
    end

    describe "#read_file_contents" do
      before(:each) do
        File.stub(:open).with("app_development.tar.gz", "rb").and_return("test")
        String.any_instance.stub(:read).and_return("test")
      end

      it "should open the File" do
        File.should_receive(:open).with("app_development.tar.gz", "rb")
        store.read_file_contents
      end

      it "should execute the read operation on the file object" do
        String.any_instance.should_receive(:read)
        store.read_file_contents
      end
    end

    describe "#fog" do
      subject{ store.fog }
      it "should return a FOG storage object with credentials" do
        subject.should be_instance_of(Fog::Storage::AWS::Real)
      end

      it "should return object with provider = 'AWS'" do
        subject.instance_variable_get(:@provider) == "AWS"
      end

      it "should return object with passed in key" do
        subject.instance_variable_get(:@aws_access_key_id) == "key"
      end

      it "should return object with passed in secret" do
        subject.instance_variable_get(:@aws_secret_access_key) == "secret"
      end
    end

  end

end