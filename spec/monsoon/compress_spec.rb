require 'spec_helper'

module Monsoon

  describe Compress do
    let(:backup) { double("backup", database: "app_development") }
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

      it "should return compress instance" do
        compress.run.should == compress
      end
    end

    describe "#compress_command" do
      before(:each) do
        compress.stub(:filename).and_return("app_development.1234.tar.gz")
        backup.stub(:database).and_return("app_development")
      end

      it "should return correct tar command" do
        compress.compress_command.should == "tar -czf app_development.1234.tar.gz app_development"
      end
    end

    describe "#filename" do

      it "should return the correct filename with timestamp" do
        compress.filename.should match("app_development.*\.tar\.gz")
      end

      it "should return original filename if subsequently requseted" do
        filename = compress.filename
        compress.filename.should == filename
      end
    end

    describe "#clean" do
      let(:filename) { compress.filename }

      it "should trigger the rm command" do
        FileUtils.should_receive(:rm).with(filename, force: true)
        compress.clean
      end

      it "should delete a file" do
        File
      end
    end

  end

end