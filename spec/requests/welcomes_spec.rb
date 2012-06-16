require 'spec_helper'

describe "Welcomes" do
  describe "GET /welcomes" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get welcomes_path
      response.status.should be(2000000)
    end
  end
end
