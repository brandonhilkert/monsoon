require 'spec_helper'

module Monsoon

  describe Compress do
    let(:backup) { double("backup", backup_directory: "tmp", database: "app_development") }
    let(:compress) { Compress.new(backup) }

    describe "initalization" do
      it "should set the @directory instance variable" do
        compress.instance_variable_get(:@backup).should == backup
      end
    end

    describe "#run" do
      before(:each) do
        compress.stub(:compress_command).and_return("tar -czf")
        Kernel.stub(:system).and_return(nil)
      end

      it "should run call on system" do
        Kernel.should_receive(:system).with("tar -czf")
        compress.run
      end

      it "should call compress method" do
        compress.should_receive(:compress_command)
        compress.run
      end
    end

    describe "#compress_command" do
      it "should include the tar command" do
        compress.compress_command.should include("tar -czf")
      end

      it "should include filename with timestamp and tar.gz extension" do
        compress.stub(:filename).and_return("app_development.1234.tar.gz")
        compress.compress_command.should include("app_development.1234.tar.gz")
      end
    end

    describe "#filename" do
      it "should return the correct filename with timestamp" do
        Time.stub_chain(:now, :utc, :to_i, :to_s).and_return("1234")
      compress.filename.should == "app_development.1234.tar.gz"
      end
    end

  end

end