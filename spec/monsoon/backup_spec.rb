require 'spec_helper'

module Monsoon

  describe Backup do
    let(:uri) { "mongodb://testuser:pass1@test.mongohq.com:10036/app_development" }

    describe "#run" do
      let(:backup) { Backup.new(uri) }

      before(:each) do
        backup.stub(:mongo_backup).and_return("mongodump -h test -p 10000")
        Kernel.stub(:system).and_return(nil)
      end

      it "should run call on system" do
        Kernel.should_receive(:system).with("mongodump -h test -p 10000")
        backup.run
      end

      it "should call mongo_dump method" do
        backup.should_receive(:mongo_backup)
        backup.run
      end
    end

    describe "#config" do
      it "should raise error if uri is not a mongodb connection string" do
        bad_uri = "http://user:pass1@test.mongohq.com:10036/app_development"

        b = Backup.new(bad_uri)
        expect { raise b.config }.to raise_error
      end

      describe "with valid URI" do
        subject{ Backup.new(uri).config }

        it "should return 'test.mongohq.com' as the host" do
          subject["host"].should == "test.mongohq.com"
        end
        
        it "should return 10036 as the port" do
          subject["port"].should == 10036
        end
        
        it "should return 'app_development' as the database" do
          subject["database"].should == "app_development"
        end
        
        it "should return 'testuser' as the username" do
          subject["username"].should == "testuser"
        end
        
        it "should return 'pass1' as the password" do
          subject["password"].should == "pass1"
        end
      end
    end

    describe "#database" do
      subject{ Backup.new(uri).database }

      it "should return 'app_development' for database" do
        subject.should == "app_development"
      end
    end

    describe "#mongo_backup" do
      subject{ Backup.new(uri).mongo_backup }

      it "should include mongo dump command" do
        subject.should include("mongodump")
      end

      it "should include switch for host including port" do
        subject.should include("-h test.mongohq.com:10036")
      end

      it "should include switch for database" do
        subject.should include("-d app_development")
      end

      it "should include switch for username" do
        subject.should include("--username testuser")
      end

      it "should include switch for password" do
        subject.should include("--password pass1")
      end

      it "should include switch for output directory" do
        subject.should include("-o tmp")
      end

      describe "when user and password is not included" do
        let(:backup) { Backup.new("mongodb://test.mongohq.com:10036/app_development").mongo_backup }

        it "should not include username switch" do
          backup.should_not include("--username")
        end

        it "should not include password switch" do
          backup.should_not include("--password")
        end
      end


    end

  end

end