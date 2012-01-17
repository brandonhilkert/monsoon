require 'spec_helper'

module Monsoon

  describe Store do

    describe "#average" do
      it "should return 4" do
        test.average(40, 10).should == 4
      end
    end

  end

end