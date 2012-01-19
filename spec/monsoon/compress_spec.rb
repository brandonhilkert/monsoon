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
        backup.stub(:backup_location).and_return("dump/app_development")
      end

      it "should return correct tar command" do
        compress.compress_command.should == "tar -czf app_development.1234.tar.gz dump/app_development"
      end
    end

    describe "#filename" do
      it "should return the correct filename with timestamp" do
        Time.stub_chain(:now, :utc, :to_i, :to_s).and_return("1234")
        compress.filename.should == "app_development_1234.tar.gz"
      end

      it "should return original filename if subsequently requseted" do
        Time.stub_chain(:now, :utc, :to_i, :to_s).and_return("1234")
        filename = compress.filename
        Time.stub_chain(:now, :utc, :to_i, :to_s).and_return("0000")
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